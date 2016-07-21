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
IUSE="cpu_flags_x86_sse4_1 test"
DEPEND="sys-libs/zlib
	app-arch/bzip2
	test? ( dev-python/nose[${PYTHON_USEDEP}] )"

REQUIRED_USE="${PYTHON_REQUIRED_USE} cpu_flags_x86_sse4_1"

#S="${WORKDIR}"/${PN}-${PN}-v${PV}

PATCHES=(
	"${FILESDIR}/${P}-shared.patch"
	"${FILESDIR}/${P}-include.patch"
	"${FILESDIR}/${P}-buildsystem.patch"
)

src_prepare() {
	# pkg-config file, taken from seqan 2.1
	cp "${FILESDIR}"/${PN}.pc.in ${PN}-${SLOT}.pc || die
	sed -e "s#@CMAKE_INSTALL_PREFIX@#${EPREFIX}/usr#" \
		-e "s#includedir=\${prefix}/include#includedir=\${prefix}/include/${PN}-${SLOT}#" \
		-e "s#@CMAKE_PROJECT_NAME@#${PN}#" \
		-e "s#@SEQAN_VERSION_STRING@#${PV}#" \
		-i ${PN}-${SLOT}.pc || die

	rm -f util/cmake/FindZLIB.cmake || die
	cmake-utils_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DBoost_NO_BOOST_CMAKE=ON
		-DSEQAN_BUILD_SYSTEM=SEQAN_RELEASE_LIBRARY
		-DSEQAN_NO_DOX=ON
	)
	cmake-utils_src_configure
}

src_install() {
	cmake-utils_src_install

	# SLOT header such that different seqan versions can be used in parallel
	mkdir "${ED}"/usr/include/${PN}-${SLOT} || die
	mv "${ED}"/usr/include/{${PN},${PN}-${SLOT}/} || die

	# pkg-config file
	insinto /usr/share/pkgconfig/
	doins ${PN}-${SLOT}.pc
}

pkg_postinst() {
	einfo "${CATEGORY}/${PF} is only intended as support library for older"
	einfo "bioinformatics tools relying on the SeqAn 1.* API. Please develop"
	einfo "any new software against the latest SeqAn release and not this one."
}
