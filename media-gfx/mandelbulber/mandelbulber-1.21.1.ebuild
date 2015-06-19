# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-gfx/mandelbulber/mandelbulber-1.21.1.ebuild,v 1.1 2014/02/08 07:20:50 radhermit Exp $

EAPI=5
inherit eutils toolchain-funcs versionator

MY_P=${PN}$(replace_version_separator 2 '-' ).orig

DESCRIPTION="Tool to render 3D fractals"
HOMEPAGE="http://sites.google.com/site/mandelbulber/home"
SRC_URI="mirror://sourceforge/${PN}/${MY_P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="x11-libs/gtk+:2
	dev-libs/glib:2
	>=media-libs/libpng-1.4:0=
	virtual/jpeg"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

S=${WORKDIR}/${MY_P}

src_prepare() {
	epatch "${FILESDIR}"/${P}-qa.patch
}

src_compile() {
	emake CXX="$(tc-getCXX)" -C makefiles all
}

src_install() {
	dobin makefiles/${PN}
	dodoc README NEWS
	insinto /usr/share/${PN}
	doins -r usr/share/*
	domenu ${PN}.desktop
}

pkg_postinst() {
	if [[ -z "${REPLACING_VERSIONS}" ]]; then
		elog "Before you run ${PN} please copy /usr/share/${PN}/* to \${HOME}/.${PN}"
	fi
}
