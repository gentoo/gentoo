# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

DESCRIPTION="HTTP Ardour Video Daemon"
HOMEPAGE="http://x42.github.io/harvid/"
SRC_URI="https://github.com/x42/harvid/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	>=media-video/ffmpeg-2.6:0=
	media-libs/libpng:0=
	virtual/jpeg:0
"
DEPEND="${RDEPEND}
	virtual/pkgconfig
"
BDEPEND="
	app-editors/vim-core
"

PATCHES=( "${FILESDIR}/jpeg.patch" )

hv_make() {
	emake \
		CC="$(tc-getCC)" \
		RANLIB="$(tc-getRANLIB)" \
		STRIP="true" \
		NM="$(tc-getNM) -B" \
		LD="$(tc-getLD)" \
		AR="$(tc-getAR)" \
		PREFIX="${EPREFIX:-/}usr" \
		libdir="${EPREFIX:-/}usr/$(get_libdir)" \
		hdocdir="${EPREFIX:-/}usr/share/doc/${PF}" \
		"${@}"
}

src_compile() {
	hv_make -C libharvid
	hv_make -C src
	hv_make
}

src_install() {
	hv_make DESTDIR="${D}" install
	dodoc ChangeLog README.md
}
