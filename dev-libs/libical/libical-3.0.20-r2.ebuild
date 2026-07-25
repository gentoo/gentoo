# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{11..14} )
VALA_USE_DEPEND="vapigen"
inherit cmake dot-a python-any-r1 toolchain-funcs vala

DESCRIPTION="Implementation of basic iCAL protocols"
HOMEPAGE="https://github.com/libical/libical"
SRC_URI="https://github.com/${PN}/${PN}/releases/download/v${PV}/${P}.tar.gz"

LICENSE="|| ( MPL-2.0 LGPL-2.1 )"
SLOT="0/3"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ~mips ppc ppc64 ~riscv ~sparc x86"
IUSE="doc examples +glib +introspection static-libs test vala"

REQUIRED_USE="introspection? ( glib ) vala? ( introspection )"
RESTRICT="!test? ( test )"

DEPEND="
	dev-libs/icu:=
	glib? (
		dev-libs/glib:2
		dev-libs/libxml2:2=
	)
"
RDEPEND="${DEPEND}
	sys-libs/timezone-data
"
BDEPEND="
	dev-lang/perl
	virtual/pkgconfig
	doc? (
		app-text/doxygen[dot]
		glib? ( dev-util/gtk-doc )
	)
	introspection? ( >=dev-libs/gobject-introspection-1.82.0-r2 )
	test? (
		${PYTHON_DEPS}
		glib? ( $(python_gen_any_dep 'dev-python/pygobject:3[${PYTHON_USEDEP}]') )
	)
	vala? ( $(vala_depend) )
"
# to build native ical-glib-src-generator w/ cross-compile
BDEPEND+="
	glib? (
		dev-libs/glib:2
		dev-libs/libxml2:2
	)
"

DOCS=(
	AUTHORS README.md ReleaseNotes.txt TEST THANKS TODO
	doc/{AddingOrModifyingComponents.txt,UsingLibical.md}
)

PATCHES=(
	"${FILESDIR}/${PN}-3.0.11-pkgconfig-libdir.patch"
	"${FILESDIR}/${P}-cmake-minreqver-3.20.patch" # bug 964491
)

python_check_deps() {
	python_has_version "dev-python/pygobject:3[${PYTHON_USEDEP}]"
}

pkg_setup() {
	use test && python-any-r1_pkg_setup
}

src_prepare() {
	cmake_src_prepare
	use vala && vala_setup
}

src_configure() {
	if tc-is-cross-compiler && use glib; then
		einfo "Building the native ical-glib-src-generator..."

		BUILD_NATIVE="${WORKDIR}/${P}_build_native"
		GENERATOR_BIN_DIR="${BUILD_NATIVE}/src/libical-glib/libexec/libical"

		local mycmakeargs=(
			-DCMAKE_DISABLE_FIND_PACKAGE_BerkeleyDB=ON
			-DICAL_BUILD_DOCS=OFF
			-DLIBICAL_BUILD_EXAMPLES=OFF
			-DGOBJECT_INTROSPECTION=OFF
			-DLIBICAL_BUILD_TESTING=OFF
			-DICAL_GLIB_VAPI=OFF
			-DICAL_GLIB=ON
		)

		BUILD_DIR="${BUILD_NATIVE}" tc-env_build cmake_src_configure

		# configure for CHOST requires a cmake...
		local native_gen=$(
			find "${BUILD_NATIVE}" -type f -name IcalGlibSrcGenerator.cmake -print
		)
		# ... and a valid path. This empty file is fine for now.
		mkdir -p "${GENERATOR_BIN_DIR}" || die
		touch "${GENERATOR_BIN_DIR}"/ical-glib-src-generator || die
	fi

	use static-libs && lto-guarantee-fat

	# fix gtk-doc, see https://bugs.gentoo.org/777090
	# to check w/ 4.0 and migration to gi-docgen
	export LD="$(tc-getCC)"

	local mycmakeargs=(
		-DCMAKE_DISABLE_FIND_PACKAGE_BerkeleyDB=ON
		-DICAL_BUILD_DOCS=$(usex doc)
		-DLIBICAL_BUILD_EXAMPLES=$(use examples)
		-DICAL_GLIB=$(usex glib)
		-DGOBJECT_INTROSPECTION=$(usex introspection)
		-DSHARED_ONLY=$(usex !static-libs)
		-DLIBICAL_BUILD_TESTING=$(usex test)
		-DICAL_GLIB_VAPI=$(usex vala)
	)

	if tc-is-cross-compiler && use glib; then
		mycmakeargs+=(
			-DIMPORT_ICAL_GLIB_SRC_GENERATOR="${native_gen}"
		)
	fi

	if use vala; then
		mycmakeargs+=(
			-DVALAC="${VALAC}"
			-DVAPIGEN="${VAPIGEN}"
		)
	fi
	cmake_src_configure
}

src_compile() {
	# build the native ical-glib-src-generator and place it where it's expected
	if tc-is-cross-compiler && use glib; then
		BUILD_DIR="${BUILD_NATIVE}" tc-env_build cmake_build ical-glib-src-generator
		ln -sfT "${BUILD_NATIVE}"/bin/ical-glib-src-generator "${GENERATOR_BIN_DIR}"/ical-glib-src-generator || die
	fi

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

	use static-libs && strip-lto-bytecode
}
