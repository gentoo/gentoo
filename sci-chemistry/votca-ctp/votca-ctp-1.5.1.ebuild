# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

CMAKE_MAKEFILE_GENERATOR="ninja"

inherit cmake-utils multilib

IUSE="doc"
if [ "${PV}" != "9999" ]; then
	SRC_URI="https://github.com/${PN/-//}/archive/v${PV}.tar.gz -> ${P}.tar.gz
		doc? ( https://github.com/${PN/-//}/releases/download/v${PV}/${PN}-manual-${PV}.pdf )"
	KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-macos"
	S="${WORKDIR}/${P#votca-}"
else
	inherit git-r3
	EGIT_REPO_URI="https://github.com/${PN/-//}.git"
	KEYWORDS=""
fi

DESCRIPTION="Votca charge transport module"
HOMEPAGE="http://www.votca.org"

LICENSE="Apache-2.0"
SLOT="0"

RDEPEND="
	~sci-libs/votca-tools-${PV}[sqlite]
	>=dev-cpp/eigen-3.3
	sci-libs/gsl
	~sci-chemistry/votca-csg-${PV}"

DEPEND="${RDEPEND}
	virtual/pkgconfig"

if [ "${PV}" != "9999" ]; then
	DEPEND="${DEPEND}
	doc? (
		app-doc/doxygen[dot]
		dev-texlive/texlive-latexextra
		virtual/latex-base
		dev-tex/pgf
	)"
fi

DOCS=( README.md NOTICE CHANGELOG.md )

src_configure() {
	[[ ${PV} = *9999* ]] && mycmakeargs=(
		-DBUILD_XTP_MANUAL=$(usex doc)
	)
	cmake-utils_src_configure
}

src_install() {
	cmake-utils_src_install
	if use doc; then
		[[ ${PV} != *9999* ]] && dodoc "${DISTDIR}/${PN}-manual-${PV}.pdf"
		cmake-utils_src_make -C "${CMAKE_BUILD_DIR}" html
		dodoc -r "${CMAKE_BUILD_DIR}"/share/doc/html
	fi
}

pkg_postinst() {
	einfo
	einfo "Please read and cite:"
	einfo "VOTCA-CTP, J. Chem. Theo. Comp. 7, 3335-3345 (2011)"
	einfo "https://dx.doi.org/10.1021/ct200388s"
	einfo
}
