# Copyright 2023-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CRATES=""
PYTHON_COMPAT=( python3_{11..14} )

inherit bash-completion-r1 cargo desktop optfeature python-any-r1

DESCRIPTION="ncurses Spotify client written in Rust using librespot"
HOMEPAGE="https://github.com/hrkfdn/ncspot"
SRC_URI="https://github.com/hrkfdn/ncspot/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"
SRC_URI+=" https://github.com/gentoo-crate-dist/${PN}/releases/download/v${PV}/${P}-crates.tar.xz"

LICENSE="BSD-2"
# Dependent crate licenses
LICENSE+=" Apache-2.0 BSD Boost-1.0 ISC MIT MPL-2.0 openssl Unicode-3.0"
SLOT="0"
KEYWORDS="amd64"

IUSE="clipboard cover mpris ncurses +notify pulseaudio"

RDEPEND="dev-libs/openssl:=
	sys-apps/dbus
	clipboard? ( x11-libs/libxcb:= )
	cover? ( media-gfx/ueberzug )
	ncurses? ( sys-libs/ncurses:= )
	!ncurses? ( sys-libs/ncurses )
	pulseaudio? ( media-libs/libpulse )
	!pulseaudio? ( media-libs/alsa-lib )"
DEPEND="${RDEPEND}"
BDEPEND="${PYTHON_DEPS}
	virtual/pkgconfig"

QA_FLAGS_IGNORED="/usr/bin/ncspot"

pkg_setup() {
	python-any-r1_pkg_setup
	rust_pkg_setup
}

src_configure() {
	local myfeaturesdef=""

	use clipboard && myfeaturesdef+="share_clipboard,share_selection,"
	use cover && myfeaturesdef+="cover,"
	use mpris && myfeaturesdef+="mpris,"
	use ncurses && myfeaturesdef+="ncurses_backend,"
	use notify && myfeaturesdef+="notify,"

	# It always seems to link to libpulse regardless of this setting if libpulse is installed.
	if use pulseaudio; then
	  myfeaturesdef+="pulseaudio_backend,"
	else
	  myfeaturesdef+="alsa_backend,"
	fi

	local myfeatures=( "${myfeaturesdef::-1}" )

	cargo_src_configure --no-default-features
}

src_compile() {
	cargo_src_compile

	cargo xtask generate-shell-completion || die
	cargo xtask generate-manpage || die
}

src_install() {
	cargo_src_install
	einstalldocs

	domenu misc/ncspot.desktop
	newicon -s scalable images/logo.svg ncspot.svg

	newbashcomp misc/ncspot.bash ncspot

	insinto /usr/share/fish/completions
	doins misc/ncspot.fish

	insinto /usr/share/zsh/site-functions
	doins misc/_ncspot

	doman misc/*.1
}

pkg_postinst() {
	optfeature_header "Optional runtime features:"
	optfeature "MPRIS song scrobbling support" media-sound/rescrobbled
}
