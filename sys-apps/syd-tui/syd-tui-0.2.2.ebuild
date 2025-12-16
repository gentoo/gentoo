# Copyright 2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CRATES="
	allocator-api2@0.2.21
	autocfg@1.5.0
	bitflags@2.10.0
	bytes@1.10.1
	cassowary@0.3.0
	castaway@0.2.4
	cfg-if@1.0.4
	cfg_aliases@0.2.1
	compact_str@0.8.1
	darling@0.20.11
	darling_core@0.20.11
	darling_macro@0.20.11
	data-encoding@2.9.0
	either@1.15.0
	equivalent@1.0.2
	fnv@1.0.7
	foldhash@0.1.5
	hashbrown@0.15.5
	heck@0.5.0
	ident_case@1.0.1
	indoc@2.0.7
	instability@0.3.9
	itertools@0.13.0
	itoa@1.0.15
	libc@0.2.177
	libredox@0.1.10
	lru@0.12.5
	memoffset@0.9.1
	mio@1.1.0
	nix@0.30.1
	numtoa@0.2.4
	paste@1.0.15
	pin-project-lite@0.2.16
	proc-macro2@1.0.103
	quote@1.0.41
	ratatui@0.29.0
	redox_syscall@0.5.18
	redox_termios@0.1.3
	rustversion@1.0.22
	ryu@1.0.20
	signal-hook-registry@1.4.6
	socket2@0.6.1
	static_assertions@1.1.0
	strsim@0.11.1
	strum@0.26.3
	strum_macros@0.26.4
	syn@2.0.108
	termion@4.0.5
	tokio@1.48.0
	unicode-ident@1.0.22
	unicode-segmentation@1.12.0
	unicode-truncate@1.1.0
	unicode-width@0.1.14
	unicode-width@0.2.0
	wasi@0.11.1+wasi-snapshot-preview1
	windows-link@0.2.1
	windows-sys@0.60.2
	windows-sys@0.61.2
	windows-targets@0.53.5
	windows_aarch64_gnullvm@0.53.1
	windows_aarch64_msvc@0.53.1
	windows_i686_gnu@0.53.1
	windows_i686_gnullvm@0.53.1
	windows_i686_msvc@0.53.1
	windows_x86_64_gnu@0.53.1
	windows_x86_64_gnullvm@0.53.1
	windows_x86_64_msvc@0.53.1
"

inherit cargo

DESCRIPTION="Syd's Terminal User Interface"
HOMEPAGE="https://man.exherbo.org"
SRC_URI="https://git.sr.ht/~alip/syd/archive/syd-tui-${PV}.tar.gz
	${CARGO_CRATE_URIS}
"

RDEPEND="sys-apps/syd"

LICENSE="GPL-3"
# Dependent crate licenses
LICENSE+="
	MIT Unicode-3.0 ZLIB
	|| ( Apache-2.0 Boost-1.0 )
"

S=${WORKDIR}/syd-${P}/tui

SLOT="0"
KEYWORDS="~amd64"
