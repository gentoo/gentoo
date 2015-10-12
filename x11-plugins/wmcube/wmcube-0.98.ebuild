# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=3

DESCRIPTION="a dockapp cpu monitor with spinning 3d objects"
HOMEPAGE="http://kling.mine.nu/kling/wmcube.htm"
SRC_URI="http://kling.mine.nu/kling/files/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 amd64 ~mips ppc ppc64 ~sparc"

IUSE=""

RDEPEND="x11-libs/libX11
	x11-libs/libXext
	x11-libs/libXpm"
DEPEND="${RDEPEND}
	x11-proto/xextproto"

S="${WORKDIR}/${P}/wmcube"

src_prepare() {
	#Honour Gentoo LDFLAGS, see bug #337893.
	sed -e "s/-o wmcube/${LDFLAGS} -o wmcube/" -i Makefile
}

src_compile() {
	emake CFLAGS="${CFLAGS}" || die "parallel make failed"
}

src_install() {
	dobin wmcube

	cd ..
	dodoc README CHANGES

	SHARE=${DESTTREE}/share/wmcube
	dodir ${SHARE}
	insinto ${SHARE}
	doins 3dObjects/*
}
