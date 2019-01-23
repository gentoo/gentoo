# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{4,5,6,7} )
inherit cmake-utils python-any-r1

DESCRIPTION="An implementation of basic iCAL protocols"
HOMEPAGE="https://github.com/libical/libical"
SRC_URI="https://github.com/${PN}/${PN}/releases/download/v${PV}/${P}.tar.gz"

LICENSE="|| ( MPL-2.0 LGPL-2.1 )"
SLOT="0/3"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 sparc ~x86 ~amd64-fbsd ~x86-fbsd ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos ~x86-solaris"
IUSE="berkdb doc examples static-libs test"

# TODO: disabled until useful
# 	glib? (
# 		dev-libs/glib:2
# 		dev-libs/libxml2:2
# 	)
# 	introspection? ( dev-libs/gobject-introspection:= )
DEPEND="
	dev-libs/icu:=
	berkdb? ( sys-libs/db:= )
"
BDEPEND="
	dev-lang/perl
	virtual/pkgconfig
	doc? ( app-doc/doxygen )
	test? ( ${PYTHON_DEPS} )
"
RDEPEND="${DEPEND}
	sys-libs/timezone-data
"

DOCS=(
	AUTHORS ReadMe.txt ReleaseNotes.txt TEST THANKS TODO
	doc/{AddingOrModifyingComponents,UsingLibical}.txt
)

PATCHES=(
	"${FILESDIR}/${PN}-3.0.1-pkgconfig-libdir.patch"
	"${FILESDIR}/${P}-tests.patch"
)

pkg_setup() {
	use test && python-any-r1_pkg_setup
}

src_prepare() {
	cmake-utils_src_prepare
	use examples || cmake_comment_add_subdirectory examples
}

src_configure() {
	local mycmakeargs=(
		-DICAL_GLIB=OFF
		-DGOBJECT_INTROSPECTION=OFF
		$(cmake-utils_use_find_package berkdb BDB)
		-DICAL_BUILD_DOCS=$(usex doc)
		-DSHARED_ONLY=$(usex !static-libs)
	)
# 	TODO: disabled until useful
# 		-DICAL_GLIB=$(usex glib)
# 		-DGOBJECT_INTROSPECTION=$(usex introspection)
	cmake-utils_src_configure
}

src_compile() {
	cmake-utils_src_compile
	use doc && cmake-utils_src_compile docs
}

src_test() {
	local myctestargs=(
		-E "(icalrecurtest|icalrecurtest-r)" # bug 660282
	)

	cmake-utils_src_test
}

src_install() {
	use doc && HTML_DOCS=( "${BUILD_DIR}"/apidocs/html/. )

	cmake-utils_src_install

	if use examples; then
		rm examples/CMakeLists.txt || die
		dodoc -r examples
	fi
}
