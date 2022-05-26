# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit vim-plugin
MY_COMMIT="87c745d8d506fc1eecc1d81df15d5bde1658a2fc"

DESCRIPTION="Vim configuration for Rust"
HOMEPAGE="https://www.rust-lang.org https://github.com/rust-lang/rust.vim"
SRC_URI="https://github.com/rust-lang/rust.vim/archive/${MY_COMMIT}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${PN/-/.}-${MY_COMMIT}"

LICENSE="|| ( MIT Apache-2.0 )"
SLOT="0"
KEYWORDS="~amd64 ~x86"

src_prepare() {
	default
	# we don't actually run these tests
	rm -r test || die
}
