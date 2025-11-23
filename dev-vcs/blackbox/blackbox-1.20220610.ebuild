# Copyright 2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Safely store secrets in a VCS repo"
HOMEPAGE="https://github.com/StackExchange/blackbox"
SRC_URI="https://github.com/StackExchange/blackbox/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"
LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	app-shells/bash
"

src_prepare() {
	default

	# Don't pollute the bin directory with shared scripts.
	sed -r -i "s:\b(source .*/)(_[^/]+\.sh)\b:\1../share/${PN}/\2:g" bin/* || die
}

src_compile() {
	:
}

src_install() {
	dobin bin/${PN}_*
	insinto /usr/share/${PN}
	doins bin/_*.sh

	dodoc AUTHORS {CHANGELOG,DESIGN,README}.md
	docinto manual
	dodoc docs/*
}
