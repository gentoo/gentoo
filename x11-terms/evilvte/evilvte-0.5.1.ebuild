# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-terms/evilvte/evilvte-0.5.1.ebuild,v 1.3 2012/05/20 09:02:35 ssuominen Exp $

EAPI=4
MY_P=${P/_/\~}
inherit toolchain-funcs savedconfig

DESCRIPTION="VTE based, super lightweight terminal emulator"
HOMEPAGE="http://www.calno.com/evilvte"
SRC_URI="http://www.calno.com/${PN}/${MY_P}.tar.xz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

RDEPEND=">=dev-libs/glib-2
	x11-libs/gtk+:3
	x11-libs/vte:2.90"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

S=${WORKDIR}/${MY_P}

DOCS=( ChangeLog )

src_prepare() {
	restore_config src/config.h
}

src_configure() {
	tc-export CC
	./configure --prefix=/usr --with-gtk=3.0 || die
}

src_compile() {
	emake -j1
}

src_install() {
	default
	save_config src/config.h
}
