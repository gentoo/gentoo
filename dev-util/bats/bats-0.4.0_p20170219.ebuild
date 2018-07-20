# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

COMMITHASH="03608115df2071fff4eaaff1605768c275e5f81f"

DESCRIPTION="An automated testing system for bash"
HOMEPAGE="https://github.com/sstephenson/bats/"
SRC_URI="https://github.com/sstephenson/bats/archive/${COMMITHASH}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"

S="${WORKDIR}/bats-${COMMITHASH}"

src_test() {
	bin/bats --tap test || die "Tests failed"
}

src_install() {
	exeinto /usr/libexec/bats
	doexe libexec/*
	dosym ../libexec/bats/bats /usr/bin/bats

	dodoc README.md
	doman man/bats.1 man/bats.7
}
