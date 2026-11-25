# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="http protocol ping-like program"
HOMEPAGE="https://www.vanheusden.com/httping/"

if [[ ${PV} == *_p* ]] ; then
	HTTPING_COMMIT="5a66c619421e6ba6267ea8c8291d6eed8c314f2a"
	SRC_URI="https://github.com/folkertvanheusden/HTTPing/archive/${HTTPING_COMMIT}.tar.gz -> ${P}.gh.tar.gz"
	S="${WORKDIR}"/HTTPing-${HTTPING_COMMIT}
else
	SRC_URI="https://github.com/folkertvanheusden/HTTPing/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"
	S="${WORKDIR}"/HTTPing-${PV}
fi

LICENSE="AGPL-3"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~hppa ~mips ~ppc ~ppc64 ~riscv ~sparc ~x86"
IUSE="fftw ncurses nls ssl"

RDEPEND="
	fftw? ( sci-libs/fftw:3.0= )
	ncurses? ( sys-libs/ncurses:= )
	ssl? ( >=dev-libs/openssl-3:= )
	nls? ( virtual/libintl )
"
DEPEND="
	${RDEPEND}
	virtual/os-headers
"
BDEPEND="
	ncurses? ( virtual/pkgconfig )
	nls? ( sys-devel/gettext )
"

src_configure() {
	local mycmakeargs=(
		-DUSE_TUI=$(usex ncurses)
		-DUSE_FFTW3=$(usex fftw)
		-DUSE_SSL=$(usex ssl)
		-DUSE_GETTEXT=$(usex nls)
	)

	cmake_src_configure
}
