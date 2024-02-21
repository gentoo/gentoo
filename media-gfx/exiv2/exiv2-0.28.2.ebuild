# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..11} )
inherit cmake-multilib python-any-r1

DESCRIPTION="EXIF, IPTC and XMP metadata C++ library and command line utility"
HOMEPAGE="https://exiv2.org/"

if [[ ${PV} == *9999* ]]; then
	EGIT_REPO_URI="https://github.com/Exiv2/exiv2.git"
	inherit git-r3
else
	SRC_URI="https://github.com/Exiv2/exiv2/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~loong ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~amd64-linux ~x86-linux ~x64-solaris"
fi

LICENSE="GPL-2"
# Upstream hope to have stable ABI in 1.0. Until then, go off ${PV}.
# We may be able to change it to $(ver_cut 1-2) once e.g.
# https://github.com/Exiv2/exiv2/pull/917 is merged.
SLOT="0/$(ver_cut 1-2)"
IUSE="+bmff doc examples nls +png test webready +xmp"
RESTRICT="!test? ( test )"

RDEPEND="
	dev-libs/inih[${MULTILIB_USEDEP}]
	>=virtual/libiconv-0-r1[${MULTILIB_USEDEP}]
	nls? ( >=virtual/libintl-0-r1[${MULTILIB_USEDEP}] )
	png? ( sys-libs/zlib[${MULTILIB_USEDEP}] )
	webready? (
		net-misc/curl[${MULTILIB_USEDEP}]
	)
	xmp? ( dev-libs/expat[${MULTILIB_USEDEP}] )
"
DEPEND="${DEPEND}
	test? ( dev-cpp/gtest )
"
BDEPEND="
	doc? (
		${PYTHON_DEPS}
		app-text/doxygen
		dev-libs/libxslt
		media-gfx/graphviz
		virtual/pkgconfig
	)
	test? ( ${PYTHON_DEPS} )
	nls? ( sys-devel/gettext )
"

DOCS=( README.md doc/ChangeLog doc/cmd.txt )

PATCHES=( "${FILESDIR}/${P}-errors-localisation.patch" )

pkg_setup() {
	if use doc || use test ; then
		python-any-r1_pkg_setup
	fi
}

src_prepare() {
	# FIXME @upstream:
	einfo "Converting doc/cmd.txt to UTF-8"
	iconv -f LATIN1 -t UTF-8 doc/cmd.txt > doc/cmd.txt.tmp || die
	mv -f doc/cmd.txt.tmp doc/cmd.txt || die

	cmake_src_prepare

	sed -e "/^include.*compilerFlags/s/^/#DONT /" -i CMakeLists.txt || die
}

multilib_src_configure() {
	local mycmakeargs=(
		-DEXIV2_BUILD_SAMPLES=NO
		-DEXIV2_ENABLE_BROTLI=OFF
		-DEXIV2_ENABLE_NLS=$(usex nls)
		-DEXIV2_ENABLE_PNG=$(usex png)
		-DEXIV2_ENABLE_CURL=$(usex webready)
		-DEXIV2_ENABLE_INIH=ON # must be enabled (bug #921937)
		-DEXIV2_ENABLE_WEBREADY=$(usex webready)
		-DEXIV2_ENABLE_XMP=$(usex xmp)
		-DEXIV2_ENABLE_BMFF=$(usex bmff)

		# We let users control this.
		-DBUILD_WITH_CCACHE=OFF
		# Our toolchain sets this by default.
		-DBUILD_WITH_STACK_PROTECTOR=OFF

		$(multilib_is_native_abi || echo -DEXIV2_BUILD_EXIV2_COMMAND=NO)
		$(multilib_is_native_abi && echo -DEXIV2_BUILD_DOC=$(usex doc))
		$(multilib_is_native_abi && echo -DEXIV2_BUILD_UNIT_TESTS=$(usex test))
		-DCMAKE_INSTALL_DOCDIR="${EPREFIX}"/usr/share/doc/${PF}/html
	)

	if use doc || use test ; then
		mycmakeargs+=(
			-DPython3_EXECUTABLE="${PYTHON}"
		)
	fi

	cmake_src_configure
}

multilib_src_compile() {
	cmake_src_compile

	if multilib_is_native_abi; then
		use doc && eninja doc
	fi
}

multilib_src_test() {
	if multilib_is_native_abi; then
		cd "${BUILD_DIR}"/bin || die
		./unit_tests || die "Failed to run tests"
	fi
}

multilib_src_install_all() {
	use xmp && DOCS+=( doc/{COPYING-XMPSDK,README-XMP,cmdxmp.txt} )

	einstalldocs
	find "${D}" -name '*.la' -delete || die

	if use examples; then
		docinto examples
		dodoc samples/*.cpp
	fi
}
