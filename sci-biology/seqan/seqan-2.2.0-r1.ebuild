# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 )

inherit cmake-utils python-any-r1 versionator

DESCRIPTION="C++ Sequence Analysis Library"
HOMEPAGE="http://www.seqan.de/"
SRC_URI="http://packages.${PN}.de/${PN}-src/${PN}-src-${PV}.tar.gz"

SLOT="0"
LICENSE="BSD GPL-3"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="cpu_flags_x86_sse4_1 doc test"
REQUIRED_USE="cpu_flags_x86_sse4_1"

RDEPEND="
	app-arch/bzip2
	sys-libs/zlib
	!!sci-biology/seqan:2.0
	!!sci-biology/seqan:2.1
	!!sci-biology/seqan:2.2"
DEPEND="
	${RDEPEND}
	doc? (
		$(python_gen_any_dep 'dev-python/sphinx[${PYTHON_USEDEP}]')
		${PYTHON_DEPS}
	)
	test? (
		$(python_gen_any_dep 'dev-python/nose[${PYTHON_USEDEP}]')
		${PYTHON_DEPS}
	)"

S="${WORKDIR}"/${PN}-${PN}-v${PV}

pkg_setup() {
	if use test || use doc; then
		python-any-r1_pkg_setup
	fi
}

src_prepare() {
	seqan_major_ver=$(get_version_component_range 1)
	seqan_majorminor_ver=$(get_version_component_range 1-2)

	# install docs in proper Gentoo structure
	sed -e "s#share/doc/seqan#share/doc/${PF}#" \
		-e "s#\"share/doc/\${APP_NAME}\"#\"share/doc/${PF}/\${APP_NAME}\"#" \
		-i util/cmake/SeqAnBuildSystem.cmake dox/CMakeLists.txt || die

	# cmake module
	sed -e "s#find_path(_SEQAN_BASEDIR \"seqan\"#find_path(_SEQAN_BASEDIR \"seqan-${seqan_majorminor_ver}\"#" \
		-e 's#NO_DEFAULT_PATH)#PATHS /usr)#' \
		-e "s#set(SEQAN_INCLUDE_DIRS_MAIN \${SEQAN_INCLUDE_DIRS_MAIN} \${_SEQAN_BASEDIR})#set(SEQAN_INCLUDE_DIRS_MAIN \${SEQAN_INCLUDE_DIRS_MAIN} \${_SEQAN_BASEDIR}/seqan-${seqan_majorminor_ver})#" \
		-i util/cmake/FindSeqAn.cmake || die

	# pkg-config file
	sed -e "s#includedir=\${prefix}/include#includedir=\${prefix}/include/${PN}-${seqan_majorminor_ver}#" \
		-i util/pkgconfig/${PN}.pc.in || die

	rm -f util/cmake/FindZLIB.cmake || die
	cmake-utils_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DSEQAN_BUILD_SYSTEM=SEQAN_RELEASE_LIBRARY
		-DSEQAN_NO_DOX=$(usex !doc)
	)
	cmake-utils_src_configure
}

src_compile() {
	cmake-utils_src_compile
	use doc && cmake-utils_src_compile -C "${BUILD_DIR}" dox
}

src_install() {
	cmake-utils_src_install

	# multi-version header such that different seqan versions can be installed in parallel
	mkdir "${ED%/}"/usr/include/${PN}-${seqan_majorminor_ver} || die
	mv "${ED%/}"/usr/include/${PN}{,-${seqan_majorminor_ver}/} || die

	# pkg-config file
	mv "${ED%/}"/usr/share/pkgconfig/${PN}-{${seqan_major_ver},${seqan_majorminor_ver}}.pc || die

	# create pkg-config symlink to restore default behaviour
	dosym ${PN}-${seqan_majorminor_ver}.pc /usr/share/pkgconfig/${PN}-${seqan_major_ver}.pc
}
