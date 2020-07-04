# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit bash-completion-r1 meson

DESCRIPTION="A commandline client for Music Player Daemon (media-sound/mpd)"
HOMEPAGE="https://www.musicpd.org https://github.com/MusicPlayerDaemon/mpc"
SRC_URI="https://www.musicpd.org/download/${PN}/${PV%.*}/${P}.tar.xz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 arm ppc ppc64 ~sparc x86"
IUSE="iconv test"
RESTRICT="!test? ( test )"

RDEPEND="media-libs/libmpdclient
	iconv? ( virtual/libiconv )"

DEPEND="${RDEPEND}
	dev-python/sphinx
	virtual/pkgconfig
	test? ( dev-libs/check )"

src_configure() {
	local emesonargs=(
		-Dtest=$(usex test true false)
		-Diconv=$(usex iconv true false)
	)
	meson_src_configure
}

src_install() {
	meson_src_install
	newbashcomp contrib/mpc-completion.bash mpc
}
