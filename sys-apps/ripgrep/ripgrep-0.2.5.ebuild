# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit cargo

DESCRIPTION="a command line search tool that combines usability with raw speed"
HOMEPAGE="https://github.com/BurntSushi/ripgrep"
SRC_URI="https://github.com/BurntSushi/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="|| ( MIT Unlicense )"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="dev-util/cargo"

src_compile() {
	cargo build --release || die
}

src_test() {
	cargo test || die "tests failed"
}

src_install() {
	dobin target/release/rg
	doman doc/rg.1
}
