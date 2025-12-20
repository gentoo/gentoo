# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

VIRTUALX_REQUIRED="always"
DOCS_BUILDER="doxygen"
DOCS_DEPEND="media-gfx/graphviz"

inherit docs qmake-utils

DESCRIPTION="Very fast real-time fractal zoomer"
HOMEPAGE="https://xaos-project.github.io/"
SRC_URI="https://github.com/xaos-project/XaoS/archive/refs/tags/release-${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/XaoS-release-${PV}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc x86"

RDEPEND="dev-qt/qtbase:6[gui,widgets]"
DEPEND="${RDEPEND}"
BDEPEND="dev-qt/qttools:6[linguist]"

src_configure() {
	# install into /usr/ instead of /usr/local
	sed -i -e "s:PREFIX = /usr/local:PREFIX = /usr:g" XaoS.pro || die
	eqmake6
	# Don't strip, this requires running X/wayland session
	sed -i -e '/$(STRIP) $(TARGET)/d' Makefile || die
	# Fix INSTALL_ROOT ignored for examples dir
	sed -i -e "s:cp {} /usr/share/XaoS/examples:cp {} \${INSTALL_ROOT}/usr/share/XaoS/examples:g" Makefile || die
}

src_compile() {
	default
	docs_compile
}

src_install() {
	INSTALL_ROOT="${ED}" default
}
