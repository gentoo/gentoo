# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CRATES="
	adler@1.0.2
	aho-corasick@1.1.3
	anstyle@1.0.7
	anyhow@1.0.86
	atty@0.2.14
	autocfg@1.3.0
	base64@0.22.1
	bitflags@1.3.2
	bitflags@2.6.0
	bytemuck@1.16.1
	byteorder@1.5.0
	cassowary@0.3.0
	cfg-if@1.0.0
	clap@4.5.9
	clap_builder@4.5.9
	clap_lex@0.7.1
	console@0.15.8
	crc32c@0.6.8
	crc32fast@1.4.2
	data-encoding@2.6.0
	downcast@0.11.0
	duct@0.13.7
	encode_unicode@0.3.6
	env_logger@0.8.4
	errno@0.3.9
	exitcode@1.1.2
	fastrand@2.1.0
	fixedbitset@0.4.2
	flate2@1.0.30
	fragile@2.0.0
	getrandom@0.2.15
	hermit-abi@0.1.19
	hermit-abi@0.3.9
	indicatif@0.17.8
	instant@0.1.13
	iovec@0.1.4
	lazy_static@1.5.0
	libc@0.2.155
	linux-raw-sys@0.4.14
	log@0.4.22
	memchr@2.7.4
	minimal-lexical@0.2.1
	miniz_oxide@0.7.4
	mockall@0.12.1
	mockall_derive@0.12.1
	nom@7.1.3
	num-derive@0.4.2
	num-traits@0.2.19
	num_cpus@1.16.0
	number_prefix@0.4.0
	numtoa@0.1.0
	once_cell@1.19.0
	os_pipe@1.2.0
	portable-atomic@1.6.0
	ppv-lite86@0.2.17
	predicates-core@1.0.6
	predicates-tree@1.0.9
	predicates@3.1.0
	proc-macro2@1.0.86
	quick-xml@0.36.0
	quickcheck@1.0.3
	quickcheck_macros@1.0.0
	quote@1.0.36
	rand@0.8.5
	rand_chacha@0.3.1
	rand_core@0.6.4
	rangemap@1.5.1
	redox_syscall@0.2.16
	redox_termios@0.1.3
	regex-automata@0.4.7
	regex-syntax@0.8.4
	regex@1.10.5
	roaring@0.10.6
	rustc_version@0.4.0
	rustix@0.38.34
	safemem@0.3.3
	semver@1.0.23
	shared_child@1.0.0
	strsim@0.11.1
	syn@1.0.109
	syn@2.0.70
	tempfile@3.10.1
	termion@1.5.6
	termtree@0.4.1
	thiserror-impl@1.0.61
	thiserror@1.0.61
	threadpool@1.8.1
	tui@0.19.0
	unicode-ident@1.0.12
	unicode-segmentation@1.11.0
	unicode-width@0.1.13
	wasi@0.11.0+wasi-snapshot-preview1
	winapi-i686-pc-windows-gnu@0.4.0
	winapi-x86_64-pc-windows-gnu@0.4.0
	winapi@0.3.9
	windows-sys@0.52.0
	windows-targets@0.52.6
	windows_aarch64_gnullvm@0.52.6
	windows_aarch64_msvc@0.52.6
	windows_i686_gnu@0.52.6
	windows_i686_gnullvm@0.52.6
	windows_i686_msvc@0.52.6
	windows_x86_64_gnu@0.52.6
	windows_x86_64_gnullvm@0.52.6
	windows_x86_64_msvc@0.52.6
"

declare -A GIT_CRATES=(
	[rio]='https://github.com/jthornber/rio;2979a720f671e836302c01546f9cc9f7988610c8;rio-%commit%'
)

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
	KEYWORDS="~amd64 ~arm ~arm64 ~loong ~mips ~ppc64 ~riscv ~s390 ~sparc ~x86 ~amd64-linux ~x86-linux"
fi

LICENSE="GPL-3"
# Dependent crate licenses
LICENSE+=" Apache-2.0 BSD GPL-3 MIT Unicode-DFS-2016"
SLOT="0"
IUSE="io-uring"

DOCS=(
	CHANGES
	COPYING
	README.md
	doc/TODO.md
	doc/thinp-version-2/notes.md
)

# Rust
QA_FLAGS_IGNORED="usr/sbin/pdata_tools"

PATCHES=(
	"${FILESDIR}/${PN}-1.0.6-build-with-cargo.patch"
)

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
