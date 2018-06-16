# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="An automated testing system for bash"
HOMEPAGE="https://github.com/bats-core/bats-core"
SRC_URI="https://github.com/bats-core/bats-core/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

S="${WORKDIR}/bats-core-${PV}"

DOCS=(
	LICENSE.md
	README.md
	Dockerfile
)

src_test() {
	bin/bats --tap test || die "Tests failed"
}

src_install() {
	exeinto /usr/libexec/bats
	doexe libexec/*
	dosym ../libexec/bats/bats /usr/bin/bats

	default
	doman man/bats.1 man/bats.7
}
