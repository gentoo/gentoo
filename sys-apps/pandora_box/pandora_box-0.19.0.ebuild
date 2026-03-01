# Copyright 2024-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

IUSE="static"

RUST_MIN_VER="1.88.0"

inherit cargo

DESCRIPTION="Syd's log inspector & profile writer"
HOMEPAGE="https://man.exherbolinux.org"

SRC_URI="https://git.sr.ht/~alip/syd/archive/pandora-${PV}.tar.gz -> ${P}.tar.gz
	https://dev.gentoo.org/~patrick/${P}-crates.tar.xz
"

S="${WORKDIR}/syd-pandora-${PV}/pandora"

LICENSE="GPL-3"
# Dependent crate licenses
LICENSE+="
	Apache-2.0 Apache-2.0-with-LLVM-exceptions BSD-2 BSD CC0-1.0 GPL-2
	ISC MIT MPL-2.0 Unicode-DFS-2016
"
SLOT="0"
KEYWORDS="~amd64"

src_configure() {
	if use static; then
		export RUSTFLAGS+="-Ctarget-feature=+crt-static"
	fi
	cargo_src_configure
}
