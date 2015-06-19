# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-plugins/wmXName/wmXName-0.1.ebuild,v 1.2 2010/08/31 13:10:02 s4t4n Exp $

MY_PV="0.01"
MY_P="${PN}-${MY_PV}"

IUSE=""
DESCRIPTION="dock-app showing you status of your XName hosted zones"
SRC_URI="http://source.xname.org/${MY_P}.tgz"
HOMEPAGE="http://source.xname.org/"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86"

COMMON_DEPEND=">=x11-libs/libXpm-3.5.7
	>=x11-libs/libX11-1.1.4
	>=x11-libs/libXext-1.0.3"

DEPEND="${COMMON_DEPEND}
	>=sys-apps/sed-4.1.5-r1"

RDEPEND="${COMMON_DEPEND}
	>=dev-lang/perl-5.8.8-r5
	>=www-client/lynx-2.8.6-r2"

S="${WORKDIR}/${MY_P}"

src_unpack() {
	unpack ${A}

	#some magic sed to fix CFLAGS
	sed -i "s/-O2 -Wall/$CFLAGS/" "${S}/Makefile"

	#INSTALL file actually contains use instructions
	mv "${S}/INSTALL" "${S}/README"
}

src_compile() {
	emake SYSTEM="${LDFLAGS}" || die
}

src_install () {
	dobin wmXName GrabXName
	dodoc README config.sample
}
