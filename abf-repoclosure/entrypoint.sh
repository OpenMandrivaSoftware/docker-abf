#!/bin/sh

# (tpg) generate index.html
cat <<EOF > /repoclosure-report/index.html
<html>
    <head>
        <title>DNF repoclosure report</title>
        <style type="text/css">
tr:nth-child(even) { background-color: #d0d0d0; }
tr:nth-child(odd) { background-color: white; }
tr.fixed { background-color: green; }
        </style>
    </head>
    <body>

<h1>DNF repoclosure report</h1>
<p>This report has been updated on $(date). <br />
<table class="contents" style="width: 159px;">
<tbody>
<tr>
<td style="width: 149px;"><strong>Main repository</strong></td>
</tr>
<tr>
<td style="width: 149px;"><a href="http://repoclosure.openmandriva.org/repoclosure-i686.html">Cooker i686</a></td>
</tr>
<tr>
<td style="width: 149px;"><a href="http://repoclosure.openmandriva.org/repoclosure-x86_64.html">Cooker x86_64</a></td>
</tr>
<tr>
<td style="width: 149px;"><a href="http://repoclosure.openmandriva.org/repoclosure-armv7hnl.html">Cooker armv7hnl</a></td>
</tr>
<tr>
<td style="width: 149px;"><a href="http://repoclosure.openmandriva.org/repoclosure-aarch64.html">Cooker aarch64</a></td>
</tr>
<tr>
<td style="width: 149px;"><a href="http://repoclosure.openmandriva.org/repoclosure-znver1.html">Cooker znver1</a></td>
</tr>
</tbody>
</table>
<hr />

</body>
</html>
EOF

# (tpg) remove any repositories
[ ! -z "$(ls -A /etc/yum.repos.d)" ] && rm -rf /etc/yum.repos.d/*

for i in i686 x86_64 armv7hnl aarch64 znver1; do
# (tpg) prepare HTML tulpe
cat <<EOF > /repoclosure-report/repoclosure-"$i".html
<html>
    <head>
        <title>DNF repoclosure report for $i</title>
        <style type="text/css">
tr:nth-child(even) { background-color: #d0d0d0; }
tr:nth-child(odd) { background-color: white; }
tr.fixed { background-color: green; }
        </style>
    </head>
    <body>
    <h1>DNF repoclosure report for $i</h1>
    <p>Generated on $(date).</p>
EOF
# (tpg) run repoclosure test
    repoclosure -q --arch "$i" --arch noarch --repofrompath=Cooker-"$i",http://abf-downloads.openmandriva.org/cooker/repository/$i/main/release/ --refresh --obsoletes --showduplicates -y >> /repoclosure-report/repoclosure-"$i".html
# (tpg) HTMLify it
    sed -i -e 's#^package: #<hr /><strong>package: </strong> #g' -e 's,unresolved deps:,<span style="color: #ff0000;"><strong>unresolved deps:</strong></span> ,g' /repoclosure-report/repoclosure-"$i".html
    printf '%s\n' '</body></html>' >> /repoclosure-report/repoclosure-"$i".html
done

