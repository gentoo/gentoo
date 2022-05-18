# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..10} )
VALA_USE_DEPEND="vapigen"
inherit cmake python-any-r1 vala

DESCRIPTION="Implementation of basic iCAL protocols"
HOMEPAGE="https://github.com/libical/libical"
SRC_URI="https://github.com/${PN}/${PN}/releases/download/v${PV}/${P}.tar.gz"

LICENSE="|| ( MPL-2.0 LGPL-2.1 )"
SLOT="0/3"
KEYWORDS="~alpha ~amd64 arm arm64 ~hppa ~ia64 ~mips ppc ppc64 ~riscv sparc ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x86-solaris"
IUSE="doc examples +glib +introspection static-libs test vala"

REQUIRED_USE="introspection? ( glib ) vala? ( introspection )"

RESTRICT="!test? ( test )"

COMMON_DEPEND="
	dev-libs/icu:=
	glib? ( dev-libs/glib:2 )
"
DEPEND="${COMMON_DEPEND}
	glib? ( dev-libs/libxml2:2 )
"
RDEPEND="${COMMON_DEPEND}
	sys-libs/timezone-data
"
BDEPEND="
	dev-lang/perl
	virtual/pkgconfig
	doc? (
		app-doc/doxygen[dot]
		glib? ( dev-util/gtk-doc )
	)
	introspection? ( dev-libs/gobject-introspection )
	test? (
		${PYTHON_DEPS}
		glib? ( $(python_gen_any_dep 'dev-python/pygobject:3[${PYTHON_USEDEP}]') )
	)
	vala? ( $(vala_depend) )
"

DOCS=(
	AUTHORS README.md ReleaseNotes.txt TEST THANKS TODO
	doc/{AddingOrModifyingComponents.txt,UsingLibical.md}
)

PATCHES=(
	"${FILESDIR}/${PN}-3.0.4-tests.patch"
	"${FILESDIR}/${PN}-3.0.11-pkgconfig-libdir.patch"
)

python_check_deps() {
	has_version "dev-python/pygobject:3[${PYTHON_USEDEP}]"
}

pkg_setup() {
	use test && python-any-r1_pkg_setup
}

src_prepare() {
	cmake_src_prepare

	use examples || cmake_comment_add_subdirectory examples
	use vala && vala_setup
}

src_configure() {
	local mycmakeargs=(
		-DCMAKE_DISABLE_FIND_PACKAGE_BerkeleyDB=ON
		-DICAL_BUILD_DOCS=$(usex doc)
		-DICAL_GLIB=$(usex glib)
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
	cmake_src_configure
}

src_compile() {
	cmake_src_compile

	if use doc; then
		cmake_src_compile docs

		HTML_DOCS=( "${BUILD_DIR}"/apidocs/html/. )
	fi
}

src_test() {
	local myctestargs=(
		-E "(icalrecurtest|icalrecurtest-r)" # bug 660282
	)

	cmake_src_test
}

src_install() {
	cmake_src_install

	if use examples; then
		rm examples/CMakeLists.txt || die
		dodoc -r examples
	fi
}
