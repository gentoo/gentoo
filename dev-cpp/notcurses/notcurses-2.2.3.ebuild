# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CMAKE_ECLASS="cmake"
inherit cmake-multilib

DESCRIPTION="Blingful TUIs and character graphics"
HOMEPAGE="https://notcurses.com"
SRC_URI="https://github.com/dankamongmen/notcurses/archive/v${PV}.tar.gz -> ${P}.tar.gz doc? ( https://github.com/dankamongmen/notcurses/releases/download/v${PV}/notcurses-doc-${PV}.tar.gz )"
LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+doc"

DEPEND="dev-libs/libunistring
	media-video/ffmpeg
	>=sys-libs/readline-8.0"
RDEPEND="${DEPEND}"

src_configure() {
	local mycmakeargs=(
		-DUSE_DOCTEST=OFF
		-DUSE_MULTIMEDIA=ffmpeg
		-DUSE_PANDOC=OFF
		-DUSE_QRCODEGEN=OFF
		-DUSE_STATIC=OFF
	)
	cmake-multilib_src_configure
}

src_compile() {
	cmake-multilib_src_compile
}

src_test() {
	multilib_src_test
}

src_install() {
	cmake-multilib_src_install
	if use doc ; then
		# we use this tortured form lest we try, every time we release a
		# x.y.1 or x.y.3, to install the source dir as a man page.
		# exploit the fact that there's a bijection from html<>man.
		for i in ../*.html ; do
			doman ../$(basename $i .html)
		done
	fi
}
