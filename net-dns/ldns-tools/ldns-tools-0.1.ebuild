# Copyright 2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs

DESCRIPTION="ldns tools: host, nslookup"
HOMEPAGE="https://gitlab.com/grobian/ldns-tools"
SRC_URI="https://gitlab.com/grobian/${PN}/-/archive/${PV}/${P}.tar.bz2"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~arm64-macos ~x64-macos ~x64-solaris"

DEPEND="
	net-libs/ldns
	sys-libs/readline
"
RDEPEND="${DEPEND}
	!net-dns/bind-tools
	!net-dns/bind
"

src_compile() {
	tc-export CC
	default
}

src_install() {
	exeinto /usr/bin
	doexe host nslookup
}
