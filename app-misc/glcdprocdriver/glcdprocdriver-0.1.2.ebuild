# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MY_PN="GLCDprocDriver"
MY_P="${MY_PN}-${PV}"

inherit toolchain-funcs

DESCRIPTION="A glue between the graphlcd-base library from the GraphLCD project"
HOMEPAGE="
	https://lucianm.github.io/GLCDprocDriver
	https://github.com/lucianm/GLCDprocDriver
"
SRC_URI="https://github.com/lucianm/${MY_PN}/archive/0.1.2.tar.gz -> ${MY_P}.tar.gz"

KEYWORDS="amd64 x86"
SLOT="0"
LICENSE="GPL-2"

DEPEND=">=app-misc/graphlcd-base-1.0.0"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${MY_P}"

src_compile() {
	emake CC="$(tc-getCC)" CXX="$(tc-getCXX)"
}

src_install() {
	emake DESTDIR="${ED}/usr" INCDIR="${ED}/usr/share/include" LIBDIR="${ED}/usr/$(get_libdir)" install

	einstalldocs
}
