# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="A static site generator in a single binary, written in Rust; simpler than Hugo"
HOMEPAGE="https://www.getzola.org"

inherit cargo git-r3

EGIT_REPO_URI="https://github.com/getzola/zola"
LICENSE="MIT"

SLOT="0"

KEYWORDS="~amd64 ~x86"
IUSE=""


DEPEND=""
RDEPEND="${DEPEND}
    >=virtual/rust-1.51
"
BDEPEND=""

src_unpack() {
	git-r3_src_unpack
	cargo_live_src_unpack
}
