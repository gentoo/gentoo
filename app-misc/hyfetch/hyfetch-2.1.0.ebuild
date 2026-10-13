# Copyright 2025-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CRATES="
	aho-corasick@1.1.4
	ansi_colours@1.2.3
	anstream@0.6.21
	anstyle-parse@0.2.7
	anstyle@1.0.14
	anyhow@1.0.102
	approx@0.5.1
	assert_float_eq@1.2.0
	autocfg@1.5.0
	bitflags@2.11.0
	bpaf@0.9.24
	by_address@1.2.1
	cfg-if@1.0.4
	colorchoice@1.0.5
	crossterm@0.29.0
	crossterm_winapi@0.9.1
	deranged@0.3.11
	deranged@0.5.8
	directories@6.0.0
	dirs-sys@0.5.0
	document-features@0.2.12
	either@1.15.0
	enable-ansi-support@0.2.1
	enterpolation@0.2.1
	env_home@0.1.0
	equivalent@1.0.2
	errno@0.3.14
	fast-srgb8@1.0.0
	fastrand@2.4.1
	fs_extra@1.3.0
	getrandom@0.2.17
	hashbrown@0.16.1
	heck@0.5.0
	indexmap@2.13.1
	is_ci@1.2.0
	is_terminal_polyfill@1.70.2
	itertools@0.14.0
	itoa@1.0.18
	lazy_static@1.5.0
	libc@0.2.184
	libredox@0.1.15
	linux-raw-sys@0.12.1
	litrs@1.0.0
	lock_api@0.4.14
	log@0.4.29
	memchr@2.8.0
	mio@1.2.0
	normpath@1.5.0
	nu-ansi-term@0.50.3
	num-conv@0.2.1
	num-traits@0.2.19
	num_threads@0.1.7
	once_cell@1.21.4
	option-ext@0.2.0
	owo-colors@4.3.0
	palette@0.7.6
	palette_derive@0.7.6
	parking_lot@0.12.5
	parking_lot_core@0.9.12
	pin-project-lite@0.2.17
	powerfmt@0.2.0
	proc-macro2@1.0.106
	quote@1.0.45
	redox_syscall@0.5.18
	redox_users@0.5.2
	regex-automata@0.4.14
	regex-syntax@0.8.10
	regex@1.12.3
	rustix@1.1.4
	same-file@1.0.6
	scopeguard@1.2.0
	serde@1.0.228
	serde_core@1.0.228
	serde_derive@1.0.228
	serde_json@1.0.149
	serde_path_to_error@0.1.20
	sharded-slab@0.1.7
	shell-words@1.1.1
	signal-hook@0.3.18
	signal-hook-mio@0.2.5
	signal-hook-registry@1.4.8
	smallvec@1.15.1
	strum@0.27.2
	strum_macros@0.27.2
	supports-color@3.0.2
	syn@2.0.117
	tempfile@3.27.0
	terminal-colorsaurus@1.0.3
	terminal-trx@0.2.6
	terminal_size@0.4.4
	thiserror-impl@1.0.69
	thiserror-impl@2.0.18
	thiserror@1.0.69
	thiserror@2.0.18
	thread_local@1.1.9
	time-core@0.1.8
	time@0.3.47
	tinyvec@1.11.0
	tinyvec_macros@0.1.1
	toml_datetime@0.7.5+spec-1.1.0
	toml_edit@0.23.10+spec-1.0.0
	toml_writer@1.1.1+spec-1.1.0
	topology-traits@0.1.2
	tracing-attributes@0.1.31
	tracing-core@0.1.36
	tracing-log@0.2.0
	tracing-subscriber@0.3.23
	tracing@0.1.44
	unicode-ident@1.0.24
	unicode-normalization@0.1.25
	unicode-segmentation@1.13.2
	utf8parse@0.2.2
	valuable@0.1.1
	wasi@0.11.1+wasi-snapshot-preview1
	which@7.0.3
	winapi-i686-pc-windows-gnu@0.4.0
	winapi-util@0.1.11
	winapi-x86_64-pc-windows-gnu@0.4.0
	winapi@0.3.9
	windows-link@0.2.1
	windows-sys@0.42.0
	windows-sys@0.61.2
	windows_aarch64_gnullvm@0.42.2
	windows_aarch64_msvc@0.42.2
	windows_i686_gnu@0.42.2
	windows_i686_msvc@0.42.2
	windows_x86_64_gnu@0.42.2
	windows_x86_64_gnullvm@0.42.2
	windows_x86_64_msvc@0.42.2
	winsafe@0.0.19
	xterm-color@1.0.2
	zmij@1.0.21
"

RUST_MIN_VER="1.88.0"
inherit cargo shell-completion optfeature

DESCRIPTION="Neofetch with LGBTQ+ pride flags!"
HOMEPAGE="https://github.com/hykilpikonna/hyfetch"
SRC_URI="https://github.com/hykilpikonna/hyfetch/archive/${PV}/${P}.tar.gz
	${CARGO_CRATE_URIS}
"

LICENSE="MIT"
# Dependent crate licenses
LICENSE+=" Apache-2.0 ISC LGPL-3+ MIT MPL-2.0 Unicode-3.0"
SLOT="0"
KEYWORDS="~amd64 ~arm64"

src_install() {
	dodir usr/bin
	dobin "$(cargo_target_dir)"/hyfetch
	newbin neofetch neowofetch
	doman docs/hyfetch.1
	newman docs/neofetch.1 neowofetch.1
	newbashcomp hyfetch/scripts/autocomplete.bash ${PN}
	newzshcomp hyfetch/scripts/autocomplete.zsh _${PN}
}
pkg_postinst() {
	optfeature "displaying images" "media-libs/imlib2 www-client/w3m[imlib]"
	optfeature "gpu detection" sys-apps/pciutils
	optfeature "thumbnail creation" media-gfx/imagemagick
	optfeature "wallpaper" media-gfx/feh x11-misc/nitrogen
	optfeature "window size" x11-misc/xdotool "x11-apps/xwininfo x11-apps/xprop" "x11-apps/xwininfo x11-apps/xdpyinfo"
	elog "The standard neofetch is installed as 'neowofetch', to avoid name conflicts."
	elog "So if you do not wish to use the pride flag functionality, you can call the"
	elog "tool that way instead."
}
