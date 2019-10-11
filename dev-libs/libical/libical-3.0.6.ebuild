# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{5,6,7} )
VALA_USE_DEPEND="vapigen"
inherit cmake-utils python-any-r1 vala

DESCRIPTION="An implementation of basic iCAL protocols"
HOMEPAGE="https://github.com/libical/libical"
SRC_URI="https://github.com/${PN}/${PN}/releases/download/v${PV}/${P}.tar.gz"

LICENSE="|| ( MPL-2.0 LGPL-2.1 )"
SLOT="0/3"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~sparc ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos ~x86-solaris"
IUSE="berkdb doc examples introspection static-libs test vala"
REQUIRED_USE="vala? ( introspection )"

BDEPEND="
	dev-lang/perl
	virtual/pkgconfig
	doc? ( app-doc/doxygen )
	test? ( ${PYTHON_DEPS} )
	vala? ( $(vala_depend) )
"
DEPEND="
	dev-libs/icu:=
	berkdb? ( sys-libs/db:= )
	introspection? (
		dev-libs/glib:2
		dev-libs/gobject-introspection:=
		dev-libs/libxml2:2
	)
"
RDEPEND="${DEPEND}
	sys-libs/timezone-data
"

DOCS=(
	AUTHORS ReadMe.txt ReleaseNotes.txt TEST THANKS TODO
	doc/{AddingOrModifyingComponents,UsingLibical}.txt
)

PATCHES=(
	"${FILESDIR}/${PN}-3.0.4-tests.patch"
	"${FILESDIR}/${PN}-3.0.5-pkgconfig-libdir.patch"
)

pkg_setup() {
	use test && python-any-r1_pkg_setup
}

src_prepare() {
	cmake-utils_src_prepare
	use examples || cmake_comment_add_subdirectory examples
	use vala && vala_src_prepare
}

src_configure() {
	local mycmakeargs=(
		$(cmake-utils_use_find_package berkdb BDB)
		-DICAL_BUILD_DOCS=$(usex doc)
		-DICAL_GLIB=$(usex introspection)
		-DGOBJECT_INTROSPECTION=$(usex introspection)
		-DSHARED_ONLY=$(usex !static-libs)
		-DLIBICAL_BUILD_TESTING=$(usex test)
		-DICAL_GLIB_VAPI=$(usex vala)
	)
	if use vala; then
		mycmakeargs+=(
			-DVALAC="${VALAC}"
			-DVAPIGEN="${VAPIGEN}"
		)
	fi
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
