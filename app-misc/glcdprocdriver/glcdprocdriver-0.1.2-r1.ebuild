# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_PN="GLCDprocDriver"
MY_P="${MY_PN}-${PV}"

inherit toolchain-funcs

DESCRIPTION="A glue between the graphlcd-base library from the GraphLCD project"
HOMEPAGE="
	https://lucianm.github.io/GLCDprocDriver
	https://github.com/lucianm/GLCDprocDriver
"
SRC_URI="https://github.com/lucianm/${MY_PN}/archive/${PV}.tar.gz -> ${MY_P}.tar.gz"
S="${WORKDIR}/${MY_P}"

KEYWORDS="amd64 x86"
SLOT="0"
LICENSE="GPL-2"

DEPEND="app-misc/graphlcd-base"
RDEPEND="${DEPEND}"

src_prepare() {
	default

	# Respect users CXX
	sed -e 's/g++/$(CXX)/g' -i Makefile || die
}

src_compile() {
	emake CC="$(tc-getCC)" CXX="$(tc-getCXX)"
}

src_install() {
	emake DESTDIR="${ED}/usr" INCDIR="${ED}/usr/share/include" LIBDIR="${ED}/usr/$(get_libdir)" install

	einstalldocs
}
