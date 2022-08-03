# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit bash-completion-r1 meson

DESCRIPTION="Commandline client for Music Player Daemon (media-sound/mpd)"
HOMEPAGE="https://www.musicpd.org https://github.com/MusicPlayerDaemon/mpc"
SRC_URI="https://www.musicpd.org/download/${PN}/${PV%.*}/${P}.tar.xz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 arm ~arm64 ppc ppc64 ~riscv ~sparc x86"
IUSE="doc iconv test"

BDEPEND="
	virtual/pkgconfig
	doc? ( dev-python/sphinx )
	iconv? ( virtual/libiconv )
	test? ( dev-libs/check )
"
DEPEND="media-libs/libmpdclient"
RDEPEND="${DEPEND}"

RESTRICT="!test? ( test )"

PATCHES=( "${FILESDIR}/${PN}-0.31-nodoc.patch" )

src_prepare() {
	default

	# use correct docdir
	sed -e "/install_dir:.*contrib/s/meson.project_name()/'${PF}'/" \
		-i meson.build || die

	# use correct (html) docdir
	sed -e "/install_dir:.*doc/s/meson.project_name()/'${PF}'/" \
		-i doc/meson.build || die
}

src_configure() {
	local emesonargs=(
		-Ddocumentation=$(usex doc enabled disabled)
		-Diconv=$(usex iconv enabled disabled)
		-Dtest=$(usex test true false)
	)
	meson_src_configure
}

src_install() {
	meson_src_install
	newbashcomp contrib/mpc-completion.bash mpc
}
