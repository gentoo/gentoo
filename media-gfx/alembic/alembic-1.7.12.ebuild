# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake multiprocessing

DESCRIPTION="Open framework for storing and sharing scene data"
HOMEPAGE="https://www.alembic.io/"
SRC_URI="https://github.com/${PN}/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+boost doc examples hdf5 prman test zlib"
RESTRICT="!test? ( test )"

REQUIRED_USE="
	${PYTHON_REQUIRED_USE}
	hdf5? ( zlib )
"

RDEPEND="
	${PYTHON_DEPS}
	>=media-libs/openexr-2.3.0:=
	boost? ( >=dev-libs/boost-1.65.0:= )
	hdf5? ( >=sci-libs/hdf5-1.10.2:=[zlib(+)] )
	zlib? ( >=sys-libs/zlib-1.2.11-r1 )
"
DEPEND="${RDEPEND}"
BDEPEND="doc? ( >=app-doc/doxygen-1.8.14-r1 )"

DOCS=( "ACKNOWLEDGEMENTS.txt" "FEEDBACK.txt" "NEWS.txt" "README.txt" )

PATCHES=(
	"${FILESDIR}/${PN}-1.7.11-0001-Fix-to-find-boost-with-cmake-3.11.patch"
	"${FILESDIR}/${PN}-1.7.11-0002-Find-IlmBase-by-setting-a-proper-ILMBASE_ROOT-value.patch"
	"${FILESDIR}/${PN}-1.7.11-0003-Fix-env-var-for-renderman.patch"
	"${FILESDIR}/${PN}-1.7.11-0004-Fix-a-compile-issue-with-const.patch"
	"${FILESDIR}/${PN}-1.7.11-0005-Fix-install-locations.patch"
	"${FILESDIR}/${PN}-1.7.11-0006-python-PyAlembic-Tests-CMakeLists.txt-fix-variable.patch"
)

src_prepare() {
	cmake_src_prepare
	if use doc; then
		doxygen -u Doxyfile || die "Failed to update Doxyfile"
		sed -i -e 's|DOT_NUM_THREADS[ \t]*= 0|DOT_NUM_THREADS = '$(makeopts_jobs)'|' Doxyfile || die "Failed to change dot threads"
	fi
}

src_configure() {
	local mycmakeargs=(
		-DALEMBIC_SHARED_LIBS=ON
		# The CMakeLists.txt file needs C++11 or C++-0x if none of them
		# is defined
		-DALEMBIC_LIB_USES_BOOST=$(usex boost)
		-DALEMBIC_LIB_USES_TR1=$(usex !boost)
		-DUSE_ARNOLD=OFF
		-DUSE_BINARIES=ON
		-DUSE_EXAMPLES=$(usex examples)
		-DUSE_HDF5=$(usex hdf5)
		-DUSE_MAYA=OFF
		-DUSE_PRMAN=$(usex prman)
		-DUSE_PYALEMBIC=OFF
		-DUSE_TESTS=$(usex test)
	)
	cmake_src_configure
}

src_compile() {
	cmake_src_compile
	if use doc; then
		doxygen Doxyfile || die "Failed to build documentation"
	fi
}

src_install() {
	use doc && local HTML_DOCS=( doc/html/. )
	cmake_src_install
}

pkg_postinst() {
	if use prman; then
		einfo "If you're looking for an ebuild for renderman, you may want to"
		einfo "try the waebbl overlay: 'eselect repository enable waebbl'"
		einfo "followed by 'emerge renderman'"
	fi
}
