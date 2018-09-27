# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

CMAKE_MAKEFILE_GENERATOR="ninja"

inherit cmake-utils multilib

IUSE=""
if [ "${PV}" != "9999" ]; then
	SRC_URI="https://github.com/${PN/-//}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
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
	~sci-chemistry/votca-csg-${PV}"

DEPEND="${RDEPEND}
	virtual/pkgconfig"

DOCS=( README NOTICE CHANGELOG.md )

src_configure() {
	mycmakeargs=(
		-DLIB=$(get_libdir)
	)
	cmake-utils_src_configure
}

pkg_postinst() {
	einfo
	einfo "Please read and cite:"
	einfo "VOTCA-CTP, J. Chem. Theo. Comp. 7, 3335-3345 (2011)"
	einfo "https://dx.doi.org/10.1021/ct200388s"
	einfo
}
