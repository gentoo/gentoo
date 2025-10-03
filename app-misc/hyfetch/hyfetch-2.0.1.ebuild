# Copyright 2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
RUST_MIN_VER="1.75.0"
CRATES="
	aho-corasick@1.1.3
	ansi_colours@1.2.3
	anstream@0.6.18
	anstyle-parse@0.2.6
	anstyle@1.0.10
	anyhow@1.0.94
	approx@0.5.1
	assert_float_eq@1.1.4
	autocfg@1.4.0
	bitflags@2.6.0
	bpaf@0.9.15
	by_address@1.2.1
	cfg-if@1.0.0
	colorchoice@1.0.3
	crossterm@0.27.0
	crossterm_winapi@0.9.1
	deranged@0.3.11
	directories@5.0.1
	dirs-sys@0.4.1
	either@1.13.0
	enable-ansi-support@0.2.1
	enterpolation@0.2.1
	env_home@0.1.0
	equivalent@1.0.1
	errno@0.3.10
	fast-srgb8@1.0.0
	fastrand@2.3.0
	fs_extra@1.3.0
	getrandom@0.2.15
	hashbrown@0.15.2
	heck@0.5.0
	indexmap@2.7.0
	is_ci@1.2.0
	is_terminal_polyfill@1.70.1
	itertools@0.13.0
	itoa@1.0.14
	lazy_static@1.5.0
	libc@0.2.168
	libredox@0.1.3
	linux-raw-sys@0.4.14
	lock_api@0.4.12
	log@0.4.22
	memchr@2.7.4
	mio@1.0.3
	normpath@1.3.0
	nu-ansi-term@0.46.0
	num-conv@0.1.0
	num-traits@0.2.19
	num_threads@0.1.7
	once_cell@1.20.2
	option-ext@0.2.0
	overload@0.1.1
	owo-colors@4.1.0
	palette@0.7.6
	palette_derive@0.7.6
	parking_lot@0.12.3
	parking_lot_core@0.9.10
	pin-project-lite@0.2.15
	powerfmt@0.2.0
	proc-macro2@1.0.92
	quote@1.0.37
	redox_syscall@0.5.7
	redox_users@0.4.6
	regex-automata@0.4.9
	regex-syntax@0.8.5
	regex@1.11.1
	rustix@0.38.42
	rustversion@1.0.18
	ryu@1.0.18
	same-file@1.0.6
	scopeguard@1.2.0
	serde@1.0.215
	serde_derive@1.0.215
	serde_json@1.0.133
	serde_path_to_error@0.1.16
	sharded-slab@0.1.7
	shell-words@1.1.0
	smallvec@1.13.2
	strum@0.26.3
	strum_macros@0.26.4
	supports-color@3.0.2
	syn@2.0.90
	tempfile@3.14.0
	terminal-colorsaurus@0.4.7
	terminal-trx@0.2.3
	terminal_size@0.3.0
	thiserror-impl@1.0.69
	thiserror@1.0.69
	thread_local@1.1.8
	time-core@0.1.2
	time@0.3.37
	tinyvec@1.8.0
	tinyvec_macros@0.1.1
	toml_datetime@0.6.8
	toml_edit@0.22.22
	topology-traits@0.1.2
	tracing-attributes@0.1.28
	tracing-core@0.1.33
	tracing-log@0.2.0
	tracing-subscriber@0.3.19
	tracing@0.1.41
	unicode-ident@1.0.14
	unicode-normalization@0.1.24
	unicode-segmentation@1.12.0
	utf8parse@0.2.2
	valuable@0.1.0
	wasi@0.11.0+wasi-snapshot-preview1
	which@7.0.1
	winapi-i686-pc-windows-gnu@0.4.0
	winapi-util@0.1.9
	winapi-x86_64-pc-windows-gnu@0.4.0
	winapi@0.3.9
	windows-sys@0.42.0
	windows-sys@0.48.0
	windows-sys@0.52.0
	windows-sys@0.59.0
	windows-targets@0.48.5
	windows-targets@0.52.6
	windows_aarch64_gnullvm@0.42.2
	windows_aarch64_gnullvm@0.48.5
	windows_aarch64_gnullvm@0.52.6
	windows_aarch64_msvc@0.42.2
	windows_aarch64_msvc@0.48.5
	windows_aarch64_msvc@0.52.6
	windows_i686_gnu@0.42.2
	windows_i686_gnu@0.48.5
	windows_i686_gnu@0.52.6
	windows_i686_gnullvm@0.52.6
	windows_i686_msvc@0.42.2
	windows_i686_msvc@0.48.5
	windows_i686_msvc@0.52.6
	windows_x86_64_gnu@0.42.2
	windows_x86_64_gnu@0.48.5
	windows_x86_64_gnu@0.52.6
	windows_x86_64_gnullvm@0.42.2
	windows_x86_64_gnullvm@0.48.5
	windows_x86_64_gnullvm@0.52.6
	windows_x86_64_msvc@0.42.2
	windows_x86_64_msvc@0.48.5
	windows_x86_64_msvc@0.52.6
	winsafe@0.0.19
"
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
KEYWORDS="~amd64"

src_install() {
	dodir usr/bin
	dobin target/release/hyfetch
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
