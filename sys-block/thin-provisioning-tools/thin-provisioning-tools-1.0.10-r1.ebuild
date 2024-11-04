# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

if [[ ${PV} != *9999 ]]; then
CRATES="
	adler@1.0.2
	aho-corasick@1.1.2
	anstyle@1.0.4
	anyhow@1.0.79
	atty@0.2.14
	autocfg@1.1.0
	base64@0.21.7
	bitflags@1.3.2
	bitflags@2.4.1
	bytemuck@1.14.0
	byteorder@1.5.0
	cassowary@0.3.0
	cfg-if@1.0.0
	clap@4.4.16
	clap_builder@4.4.16
	clap_lex@0.6.0
	console@0.15.8
	crc32c@0.6.4
	crc32fast@1.3.2
	data-encoding@2.5.0
	downcast@0.11.0
	duct@0.13.7
	either@1.9.0
	encode_unicode@0.3.6
	env_logger@0.8.4
	errno@0.3.8
	exitcode@1.1.2
	fastrand@2.0.1
	fixedbitset@0.4.2
	flate2@1.0.28
	fragile@2.0.0
	getrandom@0.2.12
	hermit-abi@0.1.19
	hermit-abi@0.3.3
	indicatif@0.17.7
	instant@0.1.12
	iovec@0.1.4
	itertools@0.11.0
	lazy_static@1.4.0
	libc@0.2.152
	linux-raw-sys@0.4.12
	log@0.4.20
	memchr@2.7.1
	minimal-lexical@0.2.1
	miniz_oxide@0.7.1
	mockall@0.12.1
	mockall_derive@0.12.1
	nom@7.1.3
	num-derive@0.4.1
	num-traits@0.2.17
	num_cpus@1.16.0
	number_prefix@0.4.0
	numtoa@0.1.0
	once_cell@1.19.0
	os_pipe@1.1.5
	portable-atomic@1.6.0
	ppv-lite86@0.2.17
	predicates-core@1.0.6
	predicates-tree@1.0.9
	predicates@3.0.4
	proc-macro2@1.0.76
	quick-xml@0.31.0
	quickcheck@1.0.3
	quickcheck_macros@1.0.0
	quote@1.0.35
	rand@0.8.5
	rand_chacha@0.3.1
	rand_core@0.6.4
	rangemap@1.4.0
	redox_syscall@0.2.16
	redox_syscall@0.4.1
	redox_termios@0.1.3
	regex-automata@0.4.3
	regex-syntax@0.8.2
	regex@1.10.2
	retain_mut@0.1.7
	roaring@0.10.2
	rustc_version@0.4.0
	rustix@0.38.30
	safemem@0.3.3
	semver@1.0.21
	shared_child@1.0.0
	strsim@0.10.0
	syn@1.0.109
	syn@2.0.48
	tempfile@3.9.0
	termion@1.5.6
	termtree@0.4.1
	thiserror-impl@1.0.56
	thiserror@1.0.56
	threadpool@1.8.1
	tui@0.19.0
	unicode-ident@1.0.12
	unicode-segmentation@1.10.1
	unicode-width@0.1.11
	wasi@0.11.0+wasi-snapshot-preview1
	winapi-i686-pc-windows-gnu@0.4.0
	winapi-x86_64-pc-windows-gnu@0.4.0
	winapi@0.3.9
	windows-sys@0.52.0
	windows-targets@0.52.0
	windows_aarch64_gnullvm@0.52.0
	windows_aarch64_msvc@0.52.0
	windows_i686_gnu@0.52.0
	windows_i686_msvc@0.52.0
	windows_x86_64_gnu@0.52.0
	windows_x86_64_gnullvm@0.52.0
	windows_x86_64_msvc@0.52.0
"

declare -A GIT_CRATES=(
	[rio]='https://github.com/jthornber/rio;2979a720f671e836302c01546f9cc9f7988610c8;rio-%commit%'
)
	declare -A GIT_CRATES=(
		[rio]="https://github.com/jthornber/rio;2979a720f671e836302c01546f9cc9f7988610c8"
	)
fi

inherit cargo

DESCRIPTION="A suite of tools for thin provisioning on Linux"
HOMEPAGE="https://github.com/jthornber/thin-provisioning-tools"

if [[ ${PV} == *9999 ]]; then
	EGIT_REPO_URI="https://github.com/jthornber/thin-provisioning-tools.git"
	inherit git-r3
else
	SRC_URI="
		https://github.com/jthornber/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz
		${CARGO_CRATE_URIS}
	"
	KEYWORDS="amd64 arm arm64 ~loong ~mips ppc64 ~riscv ~s390 sparc x86 ~amd64-linux ~x86-linux"
fi

LICENSE="GPL-3"
# Dependent crate licenses
LICENSE+=" Apache-2.0 BSD GPL-3 MIT Unicode-DFS-2016"
SLOT="0"
IUSE="io-uring"

PATCHES=( "${FILESDIR}/${PN}-1.0.6-build-with-cargo.patch" )
DOCS=(
	CHANGES
	COPYING
	README.md
	doc/TODO.md
	doc/thinp-version-2/notes.md
)

# Rust
QA_FLAGS_IGNORED="usr/sbin/pdata_tools"

src_unpack() {
	if [[ ${PV} == 9999 ]] ; then
		git-r3_src_unpack
		cargo_live_src_unpack
	else
		cargo_src_unpack
	fi
}

src_configure() {
	local myfeatures=( $(usev io-uring io_uring) )
	cargo_src_configure
}

src_install() {
	emake \
		DESTDIR="${D}" \
		DATADIR="${ED}/usr/share" \
		PDATA_TOOLS="$(cargo_target_dir)/pdata_tools" \
		install

	einstalldocs
}
