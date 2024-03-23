# Copyright 2017-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CRATES="
anstream@0.3.2
anstyle@1.0.0
anstyle-parse@0.2.0
anstyle-query@1.0.0
anstyle-wincon@1.0.1
anyhow@1.0.71
autocfg@1.1.0
bitflags@1.3.2
btrfs-backup@0.2.1
cc@1.0.79
cfg-if@1.0.0
clap@4.3.4
clap_builder@4.3.4
clap_complete@4.3.1
clap_derive@4.3.2
clap_lex@0.5.0
colorchoice@1.0.0
dashmap@5.4.0
errno@0.3.1
errno-dragonfly@0.1.2
fastrand@1.9.0
futures@0.3.28
futures-channel@0.3.28
futures-core@0.3.28
futures-executor@0.3.28
futures-io@0.3.28
futures-sink@0.3.28
futures-task@0.3.28
futures-util@0.3.28
glob@0.3.1
goblin@0.6.1
grev@0.1.3
hashbrown@0.12.3
heck@0.4.1
hermit-abi@0.3.1
instant@0.1.12
io-lifetimes@1.0.11
is-terminal@0.4.7
itoa@1.0.6
lazy_static@1.4.0
libc@0.2.146
linux-raw-sys@0.3.8
lock_api@0.4.10
log@0.4.19
memchr@2.5.0
memmap@0.7.0
num_threads@0.1.6
once_cell@1.18.0
parking_lot@0.12.1
parking_lot_core@0.9.8
pin-project-lite@0.2.9
pin-utils@0.1.0
plain@0.2.3
proc-macro2@1.0.60
quote@1.0.28
redox_syscall@0.3.5
regex@1.8.4
regex-syntax@0.7.2
rustix@0.37.20
scopeguard@1.1.0
scroll@0.11.0
scroll_derive@0.11.1
serde@1.0.164
serial_test@1.0.0
serial_test_derive@1.0.0
slab@0.4.8
smallvec@1.10.0
strsim@0.10.0
syn@1.0.109
syn@2.0.18
tempfile@3.6.0
time@0.3.22
time-core@0.1.1
time-macros@0.2.9
uname@0.1.1
unicode-ident@1.0.9
utf8parse@0.2.1
winapi@0.3.9
winapi-i686-pc-windows-gnu@0.4.0
winapi-x86_64-pc-windows-gnu@0.4.0
windows-sys@0.48.0
windows-targets@0.48.0
windows_aarch64_gnullvm@0.48.0
windows_aarch64_msvc@0.48.0
windows_i686_gnu@0.48.0
windows_i686_msvc@0.48.0
windows_x86_64_gnu@0.48.0
windows_x86_64_gnullvm@0.48.0
windows_x86_64_msvc@0.48.0
"

inherit bash-completion-r1 cargo

DESCRIPTION="A program for backup & restoration of btrfs subvolumes."
HOMEPAGE="https://github.com/d-e-s-o/btrfs-backup.git"
SRC_URI="${CARGO_CRATE_URIS}"

LICENSE="Apache-2.0 BSD-2 CC0-1.0 GPL-3+ LGPL-3 MIT"
SLOT="0"
KEYWORDS="~amd64"
# Tests require and assume sudo.
RESTRICT="test"

RDEPEND="
	${DEPEND}
	sys-fs/btrfs-progs
"
DEPEND="${RDEPEND}"

src_compile() {
	cargo_src_compile --bin="${PN}"
	# Install shell-complete binary into source directory to be able to
	# use it later on.
	cargo install --bin=shell-complete --features=clap_complete --path . --root "${S}" || die
}

src_install() {
	cargo_src_install --bin=${PN}

	"${S}"/bin/shell-complete bash > ${PN}.bash || die
	newbashcomp ${PN}.bash ${PN}

	"${S}"/bin/shell-complete fish >> ${PN}.fish || die
	insinto /usr/share/fish/vendor_conf.d/
	insopts -m0755
	newins ${PN}.fish ${PN}.fish

	einstalldocs
}
