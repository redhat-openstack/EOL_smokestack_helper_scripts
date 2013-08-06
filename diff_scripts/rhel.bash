#!/bin/bash

mkdir -p fedora
cd fedora

#ORIGIN="git@github.com:redhat-openstack"
ORIGIN="git://github.com/redhat-openstack"
FEDORA_ORIGIN="git://pkgs.fedoraproject.org"
OUTDIR="out-rhel"

mkdir -p $OUTDIR

function generate_diff {
  echo "Generating diffs..."
  for PROJ in nova glance keystone swift neutron cinder python-novaclient python-glanceclient python-keystoneclient python-swiftclient python-neutronclient python-cinderclient; do

    echo "processing $PROJ..."

    if [ -d "openstack-$PROJ" ]; then
      pushd "openstack-$PROJ"
      git fetch origin
    else
      git clone "${ORIGIN}/openstack-${PROJ}.git"
      pushd "openstack-$PROJ"
      if [ ${PROJ:0:6} = "python" ]; then
        git remote add fedoraproject "${FEDORA_ORIGIN}/${PROJ}.git"
      else
        git remote add fedoraproject "${FEDORA_ORIGIN}/openstack-${PROJ}.git"
      fi
    fi

    git fetch fedoraproject

    git diff fedoraproject/el6-grizzly origin/el6 > ../$OUTDIR/$PROJ.diff
    popd

  done

}

function generate_report {
  echo "Generating report..."
  pushd $OUTDIR

cat > index.html <<-EOF_CAT
<html>
<head>
  <title>Red Hat: package source diffs</title>
</head>
<body>
<h1>Red Hat: package source diffs</h1>

<h3>Red Hat base URL: $FEDORA_ORIGIN</h3>
<h3>Upstream base URL: $ORIGIN</h3>

Diffs by size/project:
<ul>
EOF_CAT

for DIFF in $(ls *.diff); do
  LINE_COUNT=$(wc -l $DIFF | cut -f 1 -d " ")
  echo "<li>$LINE_COUNT: <a href='$DIFF'>$DIFF</a></li>" >> index.html
done

cat >> index.html <<-EOF_CAT
</ul>

<p>
** Diffs generated with: <i>git diff fedora/el6-grizzly upstream/el6</i>
</p>

<p>
Last updated on: $(date)
</p>
</body>
</html>
EOF_CAT

popd
}

generate_diff
generate_report
