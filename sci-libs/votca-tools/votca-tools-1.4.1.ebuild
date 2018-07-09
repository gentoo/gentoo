# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

CMAKE_MAKEFILE_GENERATOR="ninja"

inherit cmake-utils eutils multilib

if [ "${PV}" != "9999" ]; then
	SRC_URI="https://github.com/${PN/-//}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-macos"
	S="${WORKDIR}/${P#votca-}"
else
	inherit git-r3
	EGIT_REPO_URI="https://github.com/${PN/-//}.git"
	KEYWORDS="~amd64 ~x86"
fi

DESCRIPTION="Votca tools library"
HOMEPAGE="http://www.votca.org"

LICENSE="Apache-2.0"
SLOT="0"
IUSE="doc +fftw +gsl sqlite"

RDEPEND="
	dev-libs/boost:=
	dev-libs/expat
	fftw? ( sci-libs/fftw:3.0 )
	gsl? ( sci-libs/gsl )
	sqlite? ( dev-db/sqlite:3 )"

DEPEND="${RDEPEND}
	doc? ( >=app-doc/doxygen-1.7.6.1[dot] )
	>=app-text/txt2tags-2.5
	virtual/pkgconfig"

DOCS=( NOTICE )

src_configure() {
	mycmakeargs=(
		-DCMAKE_DISABLE_FIND_PACKAGE_GSL=$(usex '!gsl')
		-DWITH_FFTW=$(usex fftw)
		-DWITH_SQLITE3=$(usex sqlite)
		-DWITH_RC_FILES=OFF
		-DLIB=$(get_libdir)
	)
	cmake-utils_src_configure
}

src_install() {
	cmake-utils_src_install
	if use doc; then
		cd "${CMAKE_BUILD_DIR}"
		cmake-utils_src_make html
		dodoc -r share/doc/html
	fi
}
