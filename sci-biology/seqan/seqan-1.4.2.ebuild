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
IUSE="cpu_flags_x86_sse4_1"

REQUIRED_USE="${PYTHON_REQUIRED_USE} cpu_flags_x86_sse4_1"

RDEPEND="${PYTHON_DEPS}
	sci-biology/samtools"
DEPEND="${RDEPEND}"

PATCHES=(
	"${FILESDIR}"/${P}-shared.patch
	"${FILESDIR}"/${P}-include.patch
)

src_prepare() {
	append-cppflags -msse4.1
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
