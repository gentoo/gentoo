# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit bash-completion-r1 meson

DESCRIPTION="A commandline client for Music Player Daemon (media-sound/mpd)"
HOMEPAGE="https://www.musicpd.org https://github.com/MusicPlayerDaemon/mpc"
SRC_URI="https://www.musicpd.org/download/${PN}/${PV%.*}/${P}.tar.xz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~ppc ~ppc64 ~sparc ~x86"
IUSE="iconv test"

RDEPEND="media-libs/libmpdclient"

DEPEND="${RDEPEND}
	dev-python/sphinx
	iconv? ( virtual/libiconv )
	test? ( dev-libs/check )"

BDEPEND="virtual/pkgconfig"

RESTRICT="!test? ( test )"

src_configure() {
	local emesonargs=(
		-Dtest=$(usex test true false)
		-Diconv=$(usex iconv enabled disabled)
	)
	meson_src_configure
}

src_install() {
	meson_src_install
	newbashcomp contrib/mpc-completion.bash mpc
}
