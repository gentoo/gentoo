# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit gkrellm-plugin toolchain-funcs

DESCRIPTION="A gkrellm plugin to control the MPD (Music Player Daemon)"
HOMEPAGE="http://mpd.wikia.com/wiki/Client:GKrellMPC"
SRC_URI="http://mina.naguib.ca/dist/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="threads"

RDEPEND="
	app-admin/gkrellm:2[X]
	net-misc/curl"
DEPEND="${RDEPEND}"

# Will open gkrellm in X11 display
RESTRICT="test"

PATCHES=( "${FILESDIR}/${PF}"-make-test.patch )

src_prepare() {
	if use threads; then
		PATCHES+=( "${FILESDIR}/${P}"-mt.patch )
	fi
	default
}

src_configure() {
	tc-export CC
}

pkg_postinst() {
	if use threads; then
		elog "If you can't connect MPD, please unset USE threads."
		elog "See https://bugs.gentoo.org/276970 for information."
	fi
}
