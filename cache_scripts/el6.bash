export LOCAL_REPO_DIR="rpms/el6"
export CACHEURL=${CACHEURL:?"Please set CACHEURL."}

mkdir -p "$LOCAL_REPO_DIR"

# Test if the rpms we require are in the cache allready
# If present this function downloads them to ~/rpms
function download_cached_rpm {
    rpm -q git &> /dev/null || yum install -q -y git
    local SRC_URL="$1"
    local SRC_BRANCH="$2"
    local SRC_REVISION="$3"
    local PKG_URL="$4"
    local PKG_BRANCH="$5"
   
    SRCUUID=$SRC_REVISION
    if [ -z $SRCUUID ] ; then
        SRCUUID=$(git ls-remote "$SRC_URL" "$SRC_BRANCH" | cut -f 1)
        if [ -z $SRCUUID ] ; then
            echo "Invalid source URL:BRANCH $SRC_URL:$SRC_BRANCH"
            return 1
        fi
    fi
    PKGUUID=$(git ls-remote "$PKG_URL" "$PKG_BRANCH" | cut -f 1)
    if [ -z $PKGUUID ] ; then
        echo "Invalid package URL:BRANCH $SPEC_URL:$SRC_BRANCH"
        return 1
    fi

    echo "Checking cache For $PKGUUID $SRCUUID"
    FILESFROMCACHE=$(curl -k $CACHEURL/pkgcache/pkgcache/centos/$PKGUUID/$SRCUUID 2> /dev/null) \
      || { echo "No files in RPM cache."; return 1; }

    echo "$FILESFROMCACHE"
    for file in $FILESFROMCACHE ; do
        HADFILE=1
        filename="$LOCAL_REPO_DIR/$(echo $file | sed -e 's/.*\///g')"
        echo Downloading $file -\\> $filename
        curl -k $CACHEURL/pkgcache/$file > "$filename"
        #curl $CACHEURL/$file 2> /dev/null > "$filename" || HADERROR=1
    done

    if [ -z "$HADERROR" -a -n "$HADFILE" ] ; then
        return 0
    fi
    return 1
}

#NOVA
download_cached_rpm "git://github.com/openstack/nova.git" \
                     "master" \
                     "" \
                     "git://github.com/redhat-openstack/openstack-nova.git" \
                     "el6"

download_cached_rpm "git://github.com/openstack/python-novaclient.git" \
                     "master" \
                     "" \
                     "git://github.com/redhat-openstack/openstack-python-novaclient.git" \
                     "el6"

#GLANCE
download_cached_rpm "git://github.com/openstack/glance.git" \
                    "master" \
                    "" \
                    "git://github.com/redhat-openstack/openstack-glance.git" \
                    "el6"

download_cached_rpm "git://github.com/openstack/python-glanceclient.git" \
                     "master" \
                     "" \
                     "git://github.com/redhat-openstack/openstack-python-glanceclient.git" \
                     "el6"

#KEYSTONE
download_cached_rpm "git://github.com/openstack/keystone.git" \
                    "master" \
                    "" \
                    "git://github.com/redhat-openstack/openstack-keystone.git" \
                    "el6"

download_cached_rpm "git://github.com/openstack/python-keystoneclient.git" \
                    "master" \
                    "" \
                    "git://github.com/redhat-openstack/openstack-python-keystoneclient.git" \
                    "el6"

#SWIFT
download_cached_rpm "git://github.com/openstack/swift.git" \
                    "master" \
                    "" \
                    "git://github.com/redhat-openstack/openstack-swift.git" \
                    "el6"

download_cached_rpm "git://github.com/openstack/python-swiftclient.git" \
                    "master" \
                    "" \
                    "git://github.com/redhat-openstack/openstack-python-swiftclient.git" \
                    "el6"

#CINDER
download_cached_rpm "git://github.com/openstack/cinder.git" \
                    "master" \
                    "" \
                    "git://github.com/redhat-openstack/openstack-cinder.git" \
                    "el6"

download_cached_rpm "git://github.com/openstack/python-cinderclient.git" \
                    "master" \
                    "" \
                    "git://github.com/redhat-openstack/openstack-python-cinderclient.git" \
                    "el6"

#Quantum
download_cached_rpm "git://github.com/openstack/python-neutronclient.git" \
                     "master" \
                     "" \
                     "git://github.com/redhat-openstack/openstack-python-neutronclient.git" \
                     "el6"

download_cached_rpm "git://github.com/openstack/oslo.config.git" \
                    "master" \
                    "" \
                    "git://github.com/redhat-openstack/openstack-python-oslo-config.git" \
                    "el6"

download_cached_rpm "git://github.com/openstack/oslo.sphinx.git" \
                    "master" \
                    "" \
                    "git://github.com/redhat-openstack/openstack-python-oslo-sphinx.git" \
                    "master"


#download_cached_rpm "git://github.com/fog/fog.git" \
                    #"master" \
                    #"" \
                    #"git://github.com/dprince/rubygem-fog.git" \
                    #"el6"

#download_cached_rpm "git://github.com/geemus/excon.git" \
                    #"master" \
                    #"" \
                    #"git://github.com/dprince/rubygem-excon.git" \
                    #"el6"

#download_cached_rpm "git://github.com/dprince/torpedo.git" \
                    #"master" \
                    #"" \
                    #"git://github.com/dprince/rubygem-torpedo.git" \
                    #"el6"


download_cached_rpm "git://github.com/bcwaldon/warlock.git" \
                    "master" \
                    "" \
                    "git://github.com/dprince/python-warlock.git" \
                    "master"

#jsonschema
download_cached_rpm "git://github.com/Julian/jsonschema.git" \
                    "v0.8.0" \
                    "" \
                    "git://github.com/dprince/python-jsonschema.git" \
                    "master"

#jsonpointer (for tags we use the rev of the last commit)
download_cached_rpm "git://github.com/stefankoegl/python-json-pointer.git" \
                    "v0.6" \
                    "4ca3cbad56923713da3f494a4c533534569ac61f" \
                    "git://github.com/dprince/python-jsonpointer.git" \
                    "master"

#jsonpatch (for tags we use the rev of the last commit)
download_cached_rpm "git://github.com/stefankoegl/python-json-patch.git" \
                    "v0.12" \
                    "14fa4dd06c8bd1d6d5ed4a81bf1a70326dbcd95a" \
                    "git://github.com/dprince/python-jsonpatch.git" \
                    "master"

download_cached_rpm "git://github.com/openstack-dev/pbr.git" \
                    "master" \
                    "" \
                    "git://github.com/dprince/python-pbr.git" \
                    "el6"

download_cached_rpm "git://github.com/wichert/setuptools-git.git" \
                    "master" \
                    "" \
                    "git://github.com/dprince/python-setuptools_git.git" \
                    "el6"

# remove source RPMS
mkdir -p "$LOCAL_REPO_DIR/x86_64"
mkdir -p "$LOCAL_REPO_DIR/source"
cd $LOCAL_REPO_DIR
mv *.src.rpm  source
mv *.rpm  x86_64
chmod 644 x86_64/*.rpm
chmod 644 source/*.rpm
createrepo source
createrepo x86_64
