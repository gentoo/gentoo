# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4

inherit eutils toolchain-funcs

MY_P=${PN}${PV}

DESCRIPTION="Tool to render 3D fractals"
HOMEPAGE="https://sites.google.com/site/mandelbulber/home"
SRC_URI="mirror://sourceforge/${PN}/${MY_P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="x11-libs/gtk+:2
	>=media-libs/libsndfile-1
	>=media-libs/libpng-1.4
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
}

pkg_postinst() {
	elog "Before you run ${PN} please copy /usr/share/${PN}/* to \${HOME}/.${PN}"
}
