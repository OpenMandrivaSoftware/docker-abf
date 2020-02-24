#!/bin/sh

# (tpg) generate index.html
cat <<EOF > /repoclosure-report/index.html
<html>
    <head>
        <title>OpenMandriva DNF repoclosure report</title>
        <style type="text/css">
tr:nth-child(even) { background-color: #d0d0d0; }
tr:nth-child(odd) { background-color: white; }
tr.fixed { background-color: green; }
        </style>
    </head>
    <body>

<h1 style="text-align: center;"><span style="font-size: 
      36px;">OpenMandriva DNF repoclosure report</span></h1>
<p style="text-align: center;"><span style="font-size: 
      20px;">This report has been updated on $(date)</span></p>
<p style="text-align: left;">Below you can find a number and a list of broken dependencies of RPM packages from OpenMandriva repository.</p>
<table class="contents" style="width: 57%; margin-right: calc(43%);">
  <thead>
    <tr>
      <th style="background-color: rgb(209, 213, 216);">
        <div style="text-align: left;"><strong><span style="font-size: 
      20px;">Main repository</span></strong></div>
      </th>
      <th style="background-color: rgb(209, 213, 216);">
        <div style="text-align: left;"><strong><span style="font-size: 
      20px;">Amount of broken packages</span>
            <br>
          </strong></div>
      </th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td style="width: 37.1429%;">
        <div style="text-align: left;">
          <a href="http://repoclosure.openmandriva.org/repoclosure-i686.html"><span style="font-size: 
      20px;">Cooker i686</span></a>
        </div>
      </td>
      <td style="width: 62.653%;">
        <div style="text-align: right;"><span style="font-size: 
      20px;">broken-i686</span></div>
      </td>
    </tr>
    <tr>
      <td style="width: 37.1429%; background-color: rgb(239, 239, 239);">
        <div style="text-align: left;">
          <a href="http://repoclosure.openmandriva.org/repoclosure-x86_64.html"><span style="font-size: 
      20px;">Cooker x86_64</span></a>
        </div>
      </td>
      <td style="width: 62.653%; background-color: rgb(239, 239, 239);">
        <div style="text-align: right;"><span style="font-size: 
      20px;">broken-x86_64</span></div>
      </td>
    </tr>
    <tr>
      <td style="width: 37.1429%;">
        <div style="text-align: left;">
          <a href="http://repoclosure.openmandriva.org/repoclosure-armv7hnl.html"><span style="font-size: 
      20px;">Cooker armv7hnl</span></a>
        </div>
      </td>
      <td style="width: 62.653%;">
        <div style="text-align: right;"><span style="font-size: 
      20px;">broken-armv7hnl</span></div>
      </td>
    </tr>
    <tr>
      <td style="width: 37.1429%; background-color: rgb(239, 239, 239);">
        <div style="text-align: left;">
          <a href="http://repoclosure.openmandriva.org/repoclosure-aarch64.html"><span style="font-size: 
      20px;">Cooker aarch64</span></a>
        </div>
      </td>
      <td style="width: 62.653%; background-color: rgb(239, 239, 239);">
        <div style="text-align: right;"><span style="font-size: 
      20px;">broken-aarch64</span></div>
      </td>
    </tr>
    <tr>
      <td style="width: 37.1429%;">
        <div style="text-align: left;">
          <a href="http://repoclosure.openmandriva.org/repoclosure-znver1.html"><span style="font-size: 
      20px;">Cooker znver1</span></a>
        </div>
      </td>
      <td style="width: 62.653%;">
        <div style="text-align: right;"><span style="font-size: 
      20px;">broken-znver1</span></div>
      </td>
    </tr>
  </tbody>
</table>
<p>
  <br>
</p>
<hr>
<p style="text-align: right;"><span style="font-size: 
      10px;">Author: 
    <a href="mailto:tpgxyz@gmail.com">tpgxyz@gmail.com</a>
  </span></p>
<p style="text-align: right;"><span style="font-size: 
      10px;">Sources can be found 
    <a href="https://github.com/OpenMandrivaSoftware/docker-abf/tree/master/abf-repoclosure" rel="noopener noreferrer" target="_blank">here</a>
  </span></p>

</body>
</html>
EOF

# (tpg) remove any repositories
[ ! -z "$(ls -A /etc/yum.repos.d)" ] && rm -rf /etc/yum.repos.d/*

for i in i686 x86_64 armv7hnl aarch64 znver1 riscv64; do
# (tpg) remove previous report
    [ -e /repoclosure-report/repoclosure-"$i".html ] && rm -rf /repoclosure-report/repoclosure-"$i".html

# (tpg) prepare HTML tulpe
cat <<EOF > /repoclosure-report/repoclosure-"$i".html
<html>
    <head>
        <title>OpenMandriva DNF repoclosure report for $i</title>
        <style type="text/css">
tr:nth-child(even) { background-color: #d0d0d0; }
tr:nth-child(odd) { background-color: white; }
tr.fixed { background-color: green; }
        </style>
    </head>
    <body>
<h1 style="text-align: center;"><span style="font-size: 
      36px;">OpenMandriva DNF repoclosure report for $i</span></h1>
<p style="text-align: center;"><span style="font-size: 
      20px;">This report has been generated on $(date)</span></p>
EOF

# (tpg) run repoclosure test
    dnf --setopt=keepcache=False --setopt=reposdir=/dev/null --setopt=metadata_expire=0 --disablerepo=* --repofrompath=Cooker-"$i",http://abf-downloads.openmandriva.org/cooker/repository/$i/main/release/ --enablerepo=Cooker-"$i" repoclosure --check Cooker-"$i" --arch "$i" --arch noarch --forcearch "$i" --obsoletes --showduplicates -y >> /repoclosure-report/repoclosure-"$i".html
# (tpg) HTMLify it
    sed -i -e 's#^package: #<hr /><strong>package: </strong> #g' -e 's,unresolved deps:,<span style="color: #ff0000;"><strong>unresolved deps:</strong></span> ,g' /repoclosure-report/repoclosure-"$i".html
    printf '%s\n' '</body></html>' >> /repoclosure-report/repoclosure-"$i".html
    sed -i -e "s/broken-$i/$(grep -r "package:" /repoclosure-report/repoclosure-"$i".html | wc -l)/g" /repoclosure-report/index.html
done
