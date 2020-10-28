#!/usr/bin/env python3

import os
import sys
import json
import re
import subprocess
from string import Template
from datetime import datetime

class HTMLFragments:
  INDEX_GENERATING = "<html><head><title>Repoclosure report</title></head><body><h2>Report is being regenerated...</h2></body></html>"
  INDEX_START = Template("""
<html>
  <head>
    <style>
    table.summary {
      border-collapse:collapse;
      margin-left:20px;
    }
    table.summary th, td {
      border:1px #000 solid;
    }
    table.summary tr:first-of-type td:nth-of-type(n + 2) {
      background-color:#F2F2F2;
    }
    table.summary tr:nth-of-type(n + 2) td:first-of-type {
      background-color:#F2F2F2;
    }
    table.summary th {
      text-align:center;
      font-weight:100;
      padding: 3px;
    }
    table.summary td {
      text-align:center;
      padding: 3px;
    }
    </style>
    <title>
      Repoclosure index
    </title>
  </head>
  <body>
    <h1>Repoclosure index, generated on $date</h1>
  """)

  REPORT_START=Template("""
<html>
  <head>
    <style>
      * {
        box-sizing: border-box;
        -webkit-box-sizing: border-box;
      }
      pre {
        margin: 0;
      }
      body {
        margin: 0;
      }
      .header {
        padding: 5px;
        text-align: center;
      }
      .content {
        padding: 10px;
      }
      .table {
        border-collapse: collapse;
        width: 100%;
      }
      .table th, td {
        text-align: left;
        vertical-align: top;
        padding-bottom: 15px;
        padding-top: 15px;
      }
      .table tbody tr:nth-child(odd) {
        background-color:#eee;
      }
      .table tbody tr:nth-child(even) {
        background-color:#fff;
      }
    </style>
    <title>DNF repoclosure report for $platform $repository-$arch</title>
  </head>
  <body>
    <div class="container">
      <div class="header">
        <h2>
          DNF repoclosure report for $platform $repository-$arch
        </h2>
      </div>
      <div class="content">
        <center>[ <a href="index.html">Index</a> | <a href="$report_link">$report_name</a> ]</center>
        <table class="table">
          <thead>
            $header
          </thead>
          <tbody>
  """)
  REPORT_HEADER="<tr><th>#</th><th>Package</th><th>Unresolved dependencies</th></tr>"
  COMPRESSED_REPORT_HEADER="<tr><th>#</th><th>Packages</th><th>Unresolved dependencies</th></tr>"
  REPORT_LINE=Template("<tr><td><b>$n</b></td><td>$package</td><td><pre>$unresolved</pre></td></tr>")
  COMPRESSED_REPORT_LINE=Template("<tr><td><b>$n</b></td><td><pre>$packages</pre></td><td><pre>$unresolved</pre></td></tr>")
  REPORT_END="</tbody></table></div></div></body></html>"

def render_index(counters, config, output_dir):
  filename = "%s/index.html" % output_dir
  try:
    with open(filename, "w") as index_file:
      index_file.write(
        HTMLFragments.INDEX_START.substitute(
          date = datetime.utcnow().strftime("%Y-%m-%d %H:%M:%S UTC")
        )
      )
      for platform in counters:
        repositories = list(counters[platform].keys())
        index_file.write("<h2>%s</h2>" % platform)
        index_file.write('<table class="summary">')
        index_file.write("<tr><td></td><td>" + "</td><td>".join(repositories) + "</td></tr>")
        for arch in counters[platform][repositories[0]]:
          index_file.write("<tr><td>%s</td>" % arch)
          for repository in counters[platform]:
            if isinstance(counters[platform][repository][arch], int):
              if counters[platform][repository][arch] > 0:
                path = "%s-%s-%s.html" % (platform, repository, arch)
                index_file.write('<td><a href="%s">%d</a></td>' % (path, counters[platform][repository][arch]))
              elif counters[platform][repository][arch] == 0:
                index_file.write('<td>0</td>')
            else:
              index_file.write('<td>Error: %s</td>' % counters[platform][repository][arch])
          index_file.write("</tr>")
        index_file.write('</table>')
      index_file.write("</body></html>")
  except Exception as e:
    print("Error generating index file: %s", e)
    sys.exit(1)

def render_compressed_repoclosure_report(bad_packages, platform, repository, arch, output_dir):
  compressed_bad_packages = {}
  for key in bad_packages:
    new_key = "\n".join(sorted(bad_packages[key]))
    if new_key not in compressed_bad_packages:
      compressed_bad_packages[new_key] = []
    compressed_bad_packages[new_key].append(key)

  filename = "%s/compressed-%s-%s-%s.html" % (output_dir, platform['name'], repository, arch)
  try:
    with open(filename, "w") as report_file:
      report_file.write(HTMLFragments.REPORT_START.substitute(
          platform = platform['name'],
          repository = repository,
          arch = arch,
          header = HTMLFragments.COMPRESSED_REPORT_HEADER,
          report_name = "View normal report",
          report_link = "%s-%s-%s.html" % (platform['name'], repository, arch)
        )
      )

      values = sorted(list(compressed_bad_packages.items()), key=lambda x: -len(x[1]))
      i = 1
      for unresolved_deps, packages in values:
        report_file.write(
          HTMLFragments.COMPRESSED_REPORT_LINE.substitute(
            n = i,
            unresolved = unresolved_deps,
            packages = "\n".join(packages)
          )
        )
        i += 1

      report_file.write(HTMLFragments.REPORT_END)
  except Exception as e:
    print("Error writing compressed report for %s %s-%s: %s" % (platform['name'], repository, arch, e))
    sys.exit(1)


def render_repoclosure_report(bad_packages, platform, repository, arch, output_dir):
  filename = "%s/%s-%s-%s.html" % (output_dir, platform['name'], repository, arch)
  try:
    with open(filename, "w") as report_file:
      report_file.write(HTMLFragments.REPORT_START.substitute(
          platform = platform['name'],
          repository = repository,
          arch = arch,
          header = HTMLFragments.REPORT_HEADER,
          report_name = "View compressed report",
          report_link = "compressed-%s-%s-%s.html" % (platform['name'], repository, arch)
        )
      )
      i = 1
      for package in bad_packages:
        report_file.write(
          HTMLFragments.REPORT_LINE.substitute(
            n = i,
            package = package,
            unresolved = "\n".join(bad_packages[package])
          )
        )
        i += 1

      report_file.write(HTMLFragments.REPORT_END)
  except Exception as e:
    print("Error writing report for %s %s-%s: %s" % (platform['name'], repository, arch, e))
    sys.exit(1)

def process_repoclosure_output(output):
  start = output.find("package:")
  if start == -1:
    return {}
  report = output[start:].split("\n")
  result = {}
  cur_package = ''
  cur_unresolved_deps = []
  for line in report:
    sline = line.strip()
    if sline == '':
      continue
    if sline.startswith("package:"):
      if len(cur_unresolved_deps) > 0:
        result[cur_package] = cur_unresolved_deps
      cur_package = sline.split(":")[1].split("from")[0].strip()
      cur_unresolved_deps = []
    elif sline != "unresolved deps:":
      cur_unresolved_deps.append(sline)

  if len(cur_unresolved_deps) > 0:
    result[cur_package] = cur_unresolved_deps

  return result

def generate_repoclosure_command(platform, repository, arch):
  base_url = re.sub(r'\/+$', '', platform['url'])
  cmd_parts = ['/usr/bin/dnf --setopt=keepcache=False --setopt=reposdir=/dev/null']
  cmd_parts.append('--setopt=metadata_expire=0 --disablerepo=*')
  if repository != 'main':
    main_url = base_url + ('/%s/main/release' % arch)
    cmd_parts.append('--repofrompath=main-"%s",%s --enablerepo=main-"%s"' % (arch, main_url, arch))
  repo_url = re.sub(r'\/+$', '', platform['url']) + ("/%s/%s/release" % (arch, repository))
  cmd_parts.append('--repofrompath=%s-"%s",%s --enablerepo=%s-"%s"' % (repository, arch, repo_url, repository, arch))
  cmd_parts.append('repoclosure --check %s-\"%s\" --arch \"%s\" --arch noarch \
                    --forcearch \"%s\" --obsoletes --showduplicates -y' % (repository, arch, arch, arch))

  return re.sub(r'\s+', ' ', ' '.join(cmd_parts))

def run_repoclosure(platform, repository, arch):
  platform_name = platform['name']
  print("Processing %s %s-%s" % (platform_name, repository, arch))
  cmd = generate_repoclosure_command(platform, repository, arch)

  try:
    completed_process = subprocess.run(cmd, capture_output=True, shell=True)
    return process_repoclosure_output(completed_process.stdout.decode("utf-8"))
  except Exception as e:
    print("Something went wrong when running repoclosure: %s" % e)
    return {
      error: str(e)
    }

def clear_repos():
  os.system("rm -rf /etc/yum.repos.d/*")

def clear_old_repoclosure(path):
  os.system("rm -rf %s/*.html" % path)

def load_config():
  try:
    config_text = ''
    with open("%s/config.json" % os.path.dirname(os.path.abspath(__file__)), "r") as cf:
      config_text = cf.read()

    return json.loads(config_text)
  except Exception as e:
    print("Failed to load config file at %s: %s" % (path, e))
    sys.exit(1)

def main():
  config = load_config()

  output_path = re.sub(r'\/+$', '', config['output_path'])
  try:
    if not os.path.isdir(output_path):
      os.mkdir(output_path)
    else:
      clear_old_repoclosure(output_path)

    with open(output_path + "/index.html", "w") as index_file:
      index_file.write(HTMLFragments.INDEX_GENERATING)
  except Exception as e:
    print("Don't have access to output directory or can't create one: %s" % e)
    sys.exit(1)

  index_counters = {}

  for platform in config['platforms']:
    platform_name = platform['name']
    index_counters[platform_name] = {}
    for repository in platform['repositories']:
      index_counters[platform_name][repository] = {}
      for arch in platform['arches']:
        clear_repos()
        bad_packages = run_repoclosure(platform, repository, arch)
        if 'error' in bad_packages:
          index_counters[platform_name][repository][arch] = bad_packages['error']
        elif len(bad_packages) > 0:
          index_counters[platform_name][repository][arch] = len(bad_packages)
          render_repoclosure_report(bad_packages, platform, repository, arch, config['output_path'])
          render_compressed_repoclosure_report(bad_packages, platform, repository, arch, config['output_path'])
        else:
          index_counters[platform_name][repository][arch] = 0

  render_index(index_counters, config, output_path)

if __name__ == "__main__":
  main()
