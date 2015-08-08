# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python2_7 )

inherit cmake-utils flag-o-matic python-single-r1

DESCRIPTION="C++ Sequence Analysis Library"
HOMEPAGE="http://www.seqan.de/"
SRC_URI="http://packages.${PN}.de/${PN}-src/${PN}-src-${PV}.tar.gz"

SLOT="0"
LICENSE="BSD GPL-3"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE=""

REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="${PYTHON_DEPS}
	sci-biology/samtools"
DEPEND="${RDEPEND}"

PATCHES=(
	"${FILESDIR}"/${P}-shared.patch
	"${FILESDIR}"/${P}-include.patch
)

pkg_pretend() {
	[[ ${MERGE_TYPE} = "binary" ]] && return 0
	if use amd64; then
		if ! echo "#include <smmintrin.h>" | gcc -E - 2>&1 > /dev/null; then
			ewarn "Need at least SSE4.1 support"
			die "Missing SSE4.1 support"
		fi
	fi
}

src_prepare() {
	rm -f \
		util/cmake/FindZLIB.cmake \
		|| die
	touch extras/apps/seqan_flexbar/README || die
	sed \
		-e "s:share/doc:share/doc/${PF}:g" \
		-i docs/CMakeLists.txt util/cmake/SeqAnBuildSystem.cmake || die
	cmake-utils_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DBoost_NO_BOOST_CMAKE=ON
	)
	cmake-utils_src_configure
}

src_install() {
	mkdir -p "${BUILD_DIR}"/docs/html || die
	cmake-utils_src_install
	chmod 755 "${ED}"/usr/bin/*sh || die

	mv "${ED}"/usr/bin/{,seqan-}join || die
}

pkg_postinst() {
	elog "Due to filecollision the 'join' binary has been renamed to seqan-join"
}
