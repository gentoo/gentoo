# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

MY_PV=${PV/./-}

DESCRIPTION="Common Lisp ANSI-standard Hyperspec"
HOMEPAGE="http://www.lispworks.com/reference/HyperSpec/"
SRC_URI=""
LICENSE="HyperSpec"
SLOT="0"
KEYWORDS="x86 amd64 sparc ppc"
IUSE=""
DEPEND=""

# URL: ftp://ftp.lispworks.com/pub/software_tools/reference/HyperSpec-7-0.tar.gz

S=${WORKDIR}/

src_unpack() {
	if [ ! -f ${DISTDIR}/HyperSpec-${MY_PV}.tar.gz ]; then
		while read line; do elog "${line}"; done <<EOF

The HyperSpec cannot be redistributed. Download the HyperSpec-${PV//./-}.tar.gz
file from http://www.lispworks.com/documentation/HyperSpec/ and move it to
/usr/portage/distfiles before rerunning emerge. The legal conditions are
described at http://www.lispworks.com/reference/HyperSpec/Front/Help.htm#Legal

EOF
		die
	else
		unpack HyperSpec-${MY_PV}.tar.gz
	fi
}

src_install() {
	dodir /usr/share/doc/${P}
	cp -r HyperSpec* ${D}/usr/share/doc/${P}
	dosym /usr/share/doc/${P} /usr/share/doc/hyperspec
}
