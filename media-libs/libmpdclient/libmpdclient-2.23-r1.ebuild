# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit meson flag-o-matic

DESCRIPTION="Library for interfacing Music Player Daemon (media-sound/mpd)"
HOMEPAGE="https://www.musicpd.org https://github.com/MusicPlayerDaemon/libmpdclient"
SRC_URI="https://www.musicpd.org/download/${PN}/${PV%.*}/${P}.tar.xz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 arm arm64 ppc ppc64 ~riscv ~sparc x86"
IUSE="doc examples test"
RESTRICT="!test? ( test )"

BDEPEND="doc? ( app-text/doxygen )"
DEPEND="test? ( dev-libs/check )"

src_prepare() {
	default

	# meson doesn't support setting docdir
	sed -e "/^docdir =/s/meson.project_name()/'${PF}'/" \
		-e "/^install_data(/s/'COPYING', //" \
		-i meson.build || die
}

src_configure() {
	# bug #959103
	filter-flags -fno-semantic-interposition

	local emesonargs=(
		-Ddocumentation=$(usex doc true false)
		-Dtest=$(usex test true false)
	)
	meson_src_configure
}

src_install() {
	meson_src_install
	use examples && dodoc src/example.c
}
