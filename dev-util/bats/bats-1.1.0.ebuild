# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="An automated testing system for bash"
HOMEPAGE="https://github.com/sstephenson/bats/ https://github.com/bats-core/bats-core/"
SRC_URI="https://github.com/${PN}-core/${PN}-core/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~ppc64 ~x86"
S="${WORKDIR}/${PN}-core-${PV}"

src_test() {
	bin/bats --tap test || die "Tests failed"
}

src_install() {
	dobin bin/bats
	exeinto /usr/libexec/bats-core/
	doexe libexec/bats-core/*

	dodoc README.md
	doman man/bats.1 man/bats.7
}
