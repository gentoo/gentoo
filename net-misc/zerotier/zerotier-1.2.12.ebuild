# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit flag-o-matic systemd toolchain-funcs

HOMEPAGE="https://www.zerotier.com/"
DESCRIPTION="A software-based managed Ethernet switch for planet Earth"
SRC_URI="https://github.com/zerotier/ZeroTierOne/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~x86"

S="${WORKDIR}/ZeroTierOne-${PV}"

RDEPEND="
	dev-libs/json-glib:=
	net-libs/http-parser:=
	net-libs/libnatpmp:=
	net-libs/miniupnpc:="

DEPEND="${RDEPEND}"

DOCS=( README.md AUTHORS.md )

src_compile() {
	append-ldflags -Wl,-z,noexecstack
	emake CXX="$(tc-getCXX)" STRIP=: one
}

src_test() {
	emake selftest
	./zerotier-selftest || die
}

src_install() {
	default

	newinitd "${FILESDIR}/${PN}".init "${PN}"
	systemd_dounit "${FILESDIR}/${PN}".service
	doman doc/zerotier-{cli.1,idtool.1,one.8}
}
