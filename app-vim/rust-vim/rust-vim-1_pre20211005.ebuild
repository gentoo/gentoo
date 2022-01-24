# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit vim-plugin

MY_COMMIT="4aa69b84c8a58fcec6b6dad6fe244b916b1cf830"

DESCRIPTION="Vim configuration for Rust"
HOMEPAGE="https://www.rust-lang.org https://github.com/rust-lang/rust.vim"
SRC_URI="https://github.com/rust-lang/rust.vim/archive/${MY_COMMIT}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${PN/-/.}-${MY_COMMIT}"

LICENSE="|| ( MIT Apache-2.0 )"
SLOT="0"
KEYWORDS="~amd64 ~x86"
RESTRICT="test"

src_prepare() {
	default
	# we don't actually run these tests
	rm -r test || die "Failed to remove test folder"
}
