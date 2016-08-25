# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
inherit cmake-utils

DESCRIPTION="An implementation of basic iCAL protocols"
HOMEPAGE="https://github.com/libical/libical"
SRC_URI="https://github.com/${PN}/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="|| ( MPL-1.0 LGPL-2.1 )"
SLOT="0/2"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~sparc ~x86 ~amd64-fbsd ~x86-fbsd ~x86-freebsd ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos ~x86-solaris"
IUSE="doc examples static-libs"

# The GOBJECT_INTROSPECTION build is broken, and upstream has given up
# on it at the moment (it's disabled in Travis). It will probably come
# back in v2.0.1 or later.
#RDEPEND="introspection? ( dev-libs/gobject-introspection )"
DEPEND="${RDEPEND}
	dev-lang/perl"

DOCS=(
	AUTHORS ReadMe.txt ReleaseNotes.txt TEST THANKS TODO
	doc/{AddingOrModifyingComponents,UsingLibical}.txt
)

PATCHES=( "${FILESDIR}/fix-libdir-location.patch" )

src_configure() {
	# See above, introspection is disabled for v2.0.0 at least.
	#local mycmakeargs=(
	#	-DGOBJECT_INTROSPECTION=$(usex introspection true false)
	#)
	use static-libs || mycmakeargs+=( -DSHARED_ONLY=ON )
	cmake-utils_src_configure
}

src_install() {
	cmake-utils_src_install

	if use examples; then
		rm examples/CMakeLists.txt || die
		dodoc -r examples
	fi
}
