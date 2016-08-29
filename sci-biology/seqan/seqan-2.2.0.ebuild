# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

PYTHON_COMPAT=( python2_7 )

inherit cmake-utils python-single-r1

DESCRIPTION="C++ Sequence Analysis Library"
HOMEPAGE="http://www.seqan.de/"
SRC_URI="http://packages.${PN}.de/${PN}-src/${PN}-src-${PV}.tar.gz"

SLOT="$(get_version_component_range 1-2)"
LICENSE="BSD GPL-3"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="cpu_flags_x86_sse4_1 doc test"
DEPEND="sys-libs/zlib
	app-arch/bzip2
	doc? ( dev-python/sphinx[${PYTHON_USEDEP}] )
	test? ( dev-python/nose[${PYTHON_USEDEP}] )"

REQUIRED_USE="${PYTHON_REQUIRED_USE} cpu_flags_x86_sse4_1"

S="${WORKDIR}"/${PN}-${PN}-v${PV}

src_prepare() {
	# install docs in proper Gentoo structure
	sed -e "s#share/doc/seqan#share/doc/${PF}#" \
		-e "s#\"share/doc/\${APP_NAME}\"#\"share/doc/${PF}/\${APP_NAME}\"#" \
		-i util/cmake/SeqAnBuildSystem.cmake dox/CMakeLists.txt || die

	# cmake module
	sed -e "s#find_path(_SEQAN_BASEDIR \"seqan\"#find_path(_SEQAN_BASEDIR \"seqan-${SLOT}\"#" \
		-e 's#NO_DEFAULT_PATH)#PATHS /usr)#' \
		-e "s#set(SEQAN_INCLUDE_DIRS_MAIN \${SEQAN_INCLUDE_DIRS_MAIN} \${_SEQAN_BASEDIR})#set(SEQAN_INCLUDE_DIRS_MAIN \${SEQAN_INCLUDE_DIRS_MAIN} \${_SEQAN_BASEDIR}/seqan-${SLOT})#" \
		-i util/cmake/FindSeqAn.cmake || die

	# pkg-config file
	sed -e "s#includedir=\${prefix}/include#includedir=\${prefix}/include/${PN}-${SLOT}#" \
		-i util/pkgconfig/${PN}.pc.in || die

	rm -f util/cmake/FindZLIB.cmake || die
	cmake-utils_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DBoost_NO_BOOST_CMAKE=ON
		-DSEQAN_BUILD_SYSTEM=SEQAN_RELEASE_LIBRARY
		-DSEQAN_NO_DOX="$(usex !doc)"
	)
	cmake-utils_src_configure
}

src_compile() {
	cmake-utils_src_compile
	cd "${BUILD_DIR}" || die
	use doc && emake dox
}

src_install() {
	cmake-utils_src_install

	# SLOT header such that different seqan versions can be installed in parallel
	mkdir "${ED}"/usr/include/${PN}-${SLOT} || die
	mv "${ED}"/usr/include/{${PN},${PN}-${SLOT}/} || die

	# pkg-config file
	mv "${ED}"/usr/share/pkgconfig/${PN}-{$(get_version_component_range 1),${SLOT}}.pc || die

	pushd "${ED}"/usr/share/pkgconfig/ >/dev/null
		ln -s ${PN}-{${SLOT},$(get_version_component_range 1)}.pc || die
	popd >/dev/null
}
