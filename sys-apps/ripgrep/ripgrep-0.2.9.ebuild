# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

DESCRIPTION="a command line search tool that combines usability with raw speed"
HOMEPAGE="https://github.com/BurntSushi/ripgrep"
#SRC_URI="https://github.com/BurntSushi/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"
# custom tarball bundling all deps and index, otherwise cargo fetches from the network
SRC_URI="http://dev.gentoo.org/~radhermit/dist/${P}.tar.xz"

LICENSE="|| ( MIT Unlicense )"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="
	dev-util/cargo
	dev-lang/rust
"

src_prepare() {
	default

	# move cache dir where cargo expects it
	mv .cargo "${HOME}" || die
}

src_compile() {
	cargo build --release --verbose || die
}

src_test() {
	cargo test || die "tests failed"
}

src_install() {
	dobin target/release/rg
	doman doc/rg.1
	dodoc CHANGELOG.md README.md
}
