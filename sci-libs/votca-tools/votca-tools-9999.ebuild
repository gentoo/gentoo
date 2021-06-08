# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake

if [[ ${PV} == *9999 ]]; then
	EGIT_REPO_URI="https://github.com/${PN/-//}.git"
	inherit git-r3
else
	SRC_URI="https://github.com/${PN/-//}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~x86 ~amd64-linux"
	S="${WORKDIR}/${P#votca-}"
fi

DESCRIPTION="Votca tools library"
HOMEPAGE="https://www.votca.org/"

LICENSE="Apache-2.0"
SLOT="0"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	>=dev-cpp/eigen-3.3
	dev-libs/boost:=
	dev-libs/expat
	sci-libs/fftw:3.0=
"
DEPEND="${RDEPEND}"
BDEPEND="
	virtual/pkgconfig
"

DOCS=( NOTICE README.rst CHANGELOG.rst )

src_configure() {
	local mycmakeargs=(
		-DINSTALL_RC_FILES=OFF
		-DENABLE_TESTING=$(usex test)
	)
	cmake_src_configure
}
