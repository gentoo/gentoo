# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CMAKE_MAKEFILE_GENERATOR="ninja"

inherit cmake-utils eutils multilib

if [ "${PV}" != "9999" ]; then
	SRC_URI="https://github.com/${PN/-//}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="amd64 ~x86 ~amd64-linux ~x86-macos"
	S="${WORKDIR}/${P#votca-}"
else
	inherit git-r3
	EGIT_REPO_URI="https://github.com/${PN/-//}.git"
	KEYWORDS="amd64"
fi

DESCRIPTION="Votca tools library"
HOMEPAGE="http://www.votca.org"

LICENSE="Apache-2.0"
SLOT="0"
IUSE=""

RDEPEND="
	dev-libs/boost:=
	dev-libs/expat
	>=dev-cpp/eigen-3.3
	sci-libs/fftw:3.0"

DEPEND="${RDEPEND}
	>=app-text/txt2tags-2.5
	virtual/pkgconfig"

DOCS=( NOTICE )

src_configure() {
	mycmakeargs=(
		-DWITH_RC_FILES=OFF
	)
	cmake-utils_src_configure
}
