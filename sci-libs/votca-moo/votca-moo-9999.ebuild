# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

CMAKE_MAKEFILE_GENERATOR="ninja"

inherit cmake-utils multilib

if [ "${PV}" != "9999" ]; then
	SRC_URI="https://github.com/${PN/-//}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-macos"
	S="${WORKDIR}/${P#votca-}"
else
	inherit git-r3
	EGIT_REPO_URI="https://github.com/${PN/-//}.git"
	KEYWORDS=""
fi

DESCRIPTION="Votca Molecular orbital library"
HOMEPAGE="http://www.votca.org"

LICENSE="Apache-2.0"
SLOT="0"
IUSE=""

RDEPEND="
	dev-libs/boost:=
	=sci-libs/votca-tools-${PV}[sqlite]
	dev-db/sqlite:3"

DEPEND="${RDEPEND}"

DOCS=( NOTICE README )

src_configure() {
	mycmakeargs=(
		-DLIB=$(get_libdir)
	)
	cmake-utils_src_configure
}
