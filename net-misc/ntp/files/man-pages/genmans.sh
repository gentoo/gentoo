#!/bin/bash
#
# ntpman.sh  -- Create man pages for ntp
#

VERSION=$1
if [[ -z ${VERSION} ]] ; then
	VERSION=$(ls -1d ntp-*/ 2>/dev/null | LC_COLLATE=C sort | sed -n '${s:/::;p;Q}')
	if [[ -z ${VERSION} ]] ; then
		VERSION=$(ls "${0%/*}"/../../ntp-*.ebuild | LC_COLLATE=C sort | sed -n '${s:.*/::;s:_::;s:[.]ebuild::;p;Q}')
		if [[ -z ${VERSION} ]] ; then
			echo "Usage: $0 <version>"
			exit 1
		fi
	fi
fi
[[ ${VERSION} != ntp-* ]] && VERSION="ntp-${VERSION}"

SRCDIR=${0%/*}
HTMLDIR=${SRCDIR}/${VERSION}/html
DISTFILE=/usr/portage/distfiles/${VERSION}.tar.gz
MANDIR=${SRCDIR}/man

rm -rf ${SRCDIR}/${VERSION}
if [[ ! -d ${HTMLDIR} ]] ; then
	if [[ -f ${DISTFILE} ]] ; then
		tar zxf ${DISTFILE} -C ${SRCDIR} || exit 1
	else
		echo "ERROR: $HTMLDIR / $DISTFILE does not exist"
		exit 1
	fi
fi

# Process a single HTML file
processfile() {
    HTMLFILE=$1
    MANFILE=$2
    echo -n "Processing $HTMLFILE ..."
	sed -e "s:<csobj.*<:csobj>/:" $HTMLDIR/$HTMLFILE > .$HTMLFILE
	xsltproc --html --stringparam version $VERSION ${SRCDIR}/ntp.xsl .$HTMLFILE > $MANDIR/$MANFILE || exit 1
	rm -f .$HTMLFILE
    echo "Done."
}

# Print information
echo "Generates ntp man files from HTML documentation. Using:"
echo "VERSION:   $VERSION"
echo "HTMLDIR:   $HTMLDIR"
echo "MANDIR:    $MANDIR"
echo "Press enter to continue, or Ctrl-C to cancel."
read

# Process HTML files
rm -rf ${MANDIR}
mkdir ${MANDIR}
for f in ntp{date,dc,d,q,time,trace,dsim} keygen tickadj ; do
	processfile ${f}.html ${f}.8
done
echo

cp -vi /usr/local/src/freebsd/src/usr.sbin/ntp/doc/*.5 ${MANDIR}
(
d=${PWD}
cd ${MANDIR}
shopt -s nullglob
for p in $d/*.5.patch ; do
	patch -F0 -p0 < $p || exit 1
done
) || exit 1
cp -vi ${SRCDIR}/*.patch ${SRCDIR}/genmans.sh ${SRCDIR}/ntp.xsl ${MANDIR}

tar -jcf ${VERSION}-manpages.tar.bz2 -C ${MANDIR}/.. man
du -b ${VERSION}-manpages.tar.bz2

rm -rf ${MANDIR} ${SRCDIR}/${VERSION}
