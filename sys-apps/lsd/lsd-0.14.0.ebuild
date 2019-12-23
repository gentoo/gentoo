# Copyright 2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CRATES="
ansi_term-0.11.0
atty-0.2.11
bitflags-1.0.4
chrono-0.4.6
chrono-humanize-0.0.11
clap-2.32.0
fuchsia-zircon-0.3.3
fuchsia-zircon-sys-0.3.3
kernel32-sys-0.2.2
libc-0.2.44
lscolors-0.5.0
num-integer-0.1.39
num-traits-0.2.6
rand-0.4.3
redox_syscall-0.1.43
redox_termios-0.1.1
remove_dir_all-0.5.1
strsim-0.7.0
tempdir-0.3.7
term_grid-0.1.7
term_size-0.3.1
terminal_size-0.1.8
termion-1.5.1
textwrap-0.10.0
time-0.1.40
unicode-width-0.1.5
users-0.8.1
vec_map-0.8.1
version_check-0.1.5
winapi-0.2.8
winapi-0.3.6
winapi-build-0.1.1
winapi-i686-pc-windows-gnu-0.4.0
winapi-x86_64-pc-windows-gnu-0.4.0
"

inherit cargo

DESCRIPTION="A modern ls with a lot of pretty colors and awesome icons"
HOMEPAGE="https://github.com/Peltoche/lsd"
SRC_URI="https://github.com/Peltoche/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz
	$(cargo_crate_uris ${CRATES})"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 ~x86"
IUSE=""

DEPEND=""
RDEPEND=""
BDEPEND=">=virtual/rust-1.31.0"

QA_FLAGS_IGNORED="/usr/bin/lsd"

src_install() {
	cargo_src_install
	einstalldocs
}
