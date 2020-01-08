#! /bin/bash

# Adjusted from OpenSUSE script
# Source: https://build.opensuse.org/package/view_file/openSUSE:Factory/csound/pre_checkin.sh

VERSION="${1}"

if [[ -z "${VERSION}" ]]; then
	echo "Version must be specified"
	exit 1
fi

rm -f *.tar.*

wget https://github.com/csound/csound/archive/${VERSION}.tar.gz || exit 1

echo -e "\n\nUnpacking tarball\n"
tar -xf ${VERSION}.tar.gz

echo -e "Removing undistibutable files\n"
rm -f csound-${VERSION}/Opcodes/scansyn*

echo -e "Creating distributable tarball\n"
tar -acf csound-${VERSION}-distributable.tar.xz csound-${VERSION}

echo -e "Cleaning up\n"
rm -rf csound-${VERSION} ${VERSION}.tar.gz

if ! test -e ${VERSION}.tar.gz; then
	echo "success"
	exit 0
else
	echo "error"
	exit 1
fi
