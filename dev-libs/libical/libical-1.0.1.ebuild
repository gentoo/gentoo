# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/libical/libical-1.0.1.ebuild,v 1.7 2015/06/30 04:45:17 jer Exp $

EAPI=5
inherit cmake-utils

DESCRIPTION="An implementation of basic iCAL protocols"
HOMEPAGE="http://github.com/libical/libical"
SRC_URI="http://github.com/${PN}/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

# FIGURE OUT: Why ebuild for 1.0 was marked || ( MPL-1.1 LGPL-2 ) against what COPYING file says?
LICENSE="|| ( MPL-1.0 LGPL-2.1 )"
SLOT="0/1"
KEYWORDS="~alpha amd64 ~arm ~arm64 hppa ~ia64 ~mips ~ppc ppc64 ~sparc x86 ~amd64-fbsd ~x86-fbsd ~x86-freebsd ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos ~x86-solaris"
IUSE="doc examples introspection static-libs"

RDEPEND="introspection? ( dev-libs/gobject-introspection )"
DEPEND="${RDEPEND}
	dev-lang/perl"

DOCS=(
	AUTHORS ReadMe.txt ReleaseNotes.txt TEST THANKS TODO
	doc/{AddingOrModifyingComponents,UsingLibical}.txt
)

src_configure() {
	local mycmakeargs=( $(cmake-utils_use introspection GOBJECT_INTROSPECTION) )
	use static-libs || mycmakeargs+=( -DSHARED_ONLY=ON )
	cmake-utils_src_configure
}

src_compile() {
	cmake-utils_src_compile -j1
}

src_install() {
	cmake-utils_src_install

	if use examples; then
		rm examples/Makefile* examples/CMakeLists.txt
		insinto /usr/share/doc/${PF}/examples
		doins examples/*
	fi
}
