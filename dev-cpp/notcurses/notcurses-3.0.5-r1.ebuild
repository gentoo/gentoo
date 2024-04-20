# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="Blingful TUIs and character graphics"
HOMEPAGE="https://notcurses.com"
SRC_URI="https://github.com/dankamongmen/notcurses/archive/v${PV}.tar.gz -> ${P}.tar.gz
	https://github.com/dankamongmen/notcurses/releases/download/v${PV}/notcurses-doc-${PV}.tar.gz"
LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="dev-libs/libunistring:=
	media-video/ffmpeg:=
	sys-libs/gpm
	sys-libs/ncurses:="
RDEPEND="${DEPEND}"

src_configure() {
	local mycmakeargs=(
		-DUSE_DEFLATE=OFF
		-DUSE_DOCTEST=OFF
		-DUSE_GPM=ON
		-DUSE_MULTIMEDIA=ffmpeg
		-DUSE_PANDOC=OFF
		-DUSE_QRCODEGEN=OFF
		-DUSE_STATIC=OFF
	)
	cmake_src_configure
}

src_test() {
	ewarn "Tests will fail if you don't have a UTF8 locale available,"
	ewarn "or if you're missing the proper terminfo database for your TERM."

	cmake_src_test
}

src_install() {
	cmake_src_install

	# we use this tortured form lest we try, every time we release a
	# x.y.1 or x.y.3, to install the source dir as a man page.
	# exploit the fact that there's a bijection from html<>man.
	for i in ../*.html ; do
		doman ../$(basename ${i} .html || die)
	done
}
