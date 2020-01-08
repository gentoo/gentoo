# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit meson

DESCRIPTION="A library for interfacing Music Player Daemon (media-sound/mpd)"
HOMEPAGE="https://www.musicpd.org https://github.com/MusicPlayerDaemon/libmpdclient"
SRC_URI="https://www.musicpd.org/download/${PN}/${PV%.*}/${P}.tar.xz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="alpha amd64 arm ppc ppc64 ~sparc x86"
IUSE="doc examples test"
RESTRICT="!test? ( test )"

RDEPEND=""
DEPEND="
	doc? ( app-doc/doxygen )
	test? ( dev-libs/check )
"

src_prepare() {
	default

	sed -i "s:@top_srcdir@:.:" doc/doxygen.conf.in || die

	# meson doesn't support setting docdir
	sed -e "/^docdir =/s/meson.project_name()/'${PF}'/" \
		-e "/^install_data(/s/'COPYING', //" \
		-i meson.build || die
}

src_configure() {
	local emesonargs=(
		-Ddocumentation=$(usex doc true false)
		-Dtest=$(usex test true false)
	)
	meson_src_configure
}

src_install() {
	meson_src_install

	use examples && dodoc src/example.c
	use doc || rm -rf "${ED}"/usr/share/doc/${PF}/html
}
