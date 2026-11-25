# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Yamaha DX7 modeling DSSI plugin"
HOMEPAGE="http://smbolton.com/hexter.html"
SRC_URI="https://github.com/smbolton/${PN}/releases/download/version_${PV}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="readline"

BDEPEND="
	sys-apps/ed
	virtual/pkgconfig
"
RDEPEND="
	media-libs/alsa-lib
	media-libs/dssi
	media-libs/liblo
	readline? ( sys-libs/readline:0= )
"
DEPEND="${RDEPEND}
	media-libs/ladspa-sdk
"

src_prepare() {
	local -a ed_cmds

	default

	# Per bug #837680, the readline check tries -lcurses, then -ltermcap.
	# Gentoo no longer provides -lcurses. The text UI uses no curses functions,
	# and libreadline already links against ncurses, so use -lreadline alone.
	ed_cmds=(
		'/^LIBS="-lreadline -lcurses \$LIBS"$/c'
		'LIBS="-lreadline $LIBS"'
		.

		"/^  READLINE_LIBS='-lreadline -lcurses'\$/c"
		"  READLINE_LIBS='-lreadline'"
		.
	)
	printf '%s\n' H "${ed_cmds[@]}" w q \
	| ed -s configure || die "Failed to patch readline linkage in configure"
}

src_configure() {
	PKG_CONFIG=pkg-config \
	econf --without-gtk2 \
		$(use_with readline textui)
}

src_install() {
	default
	find "${D}" -name '*.la' -delete || die
}
