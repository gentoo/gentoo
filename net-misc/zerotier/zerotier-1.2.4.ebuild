# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit flag-o-matic toolchain-funcs systemd

HOMEPAGE="https://www.zerotier.com/"
DESCRIPTION="A software-based managed Ethernet switch for planet Earth"
SRC_URI="https://github.com/zerotier/ZeroTierOne/archive/${PV}.tar.gz -> zerotier-${PV}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"

S="${WORKDIR}/ZeroTierOne-${PV}"

RDEPEND="
	net-libs/miniupnpc
	net-libs/libnatpmp
	dev-libs/json-glib
	net-libs/http-parser"

DEPEND="${RDEPEND}
	>=sys-devel/gcc-4.9.3"

QA_PRESTRIPPED="/usr/sbin/zerotier-one"

DOCS=( README.md AUTHORS.md )

src_compile() {
	append-ldflags -Wl,-z,noexecstack
	emake CXX="$(tc-getCXX)" one
}

src_install() {
	default

	newinitd "${FILESDIR}/${PN}.init" "${PN}"
	systemd_dounit "${FILESDIR}/${PN}.service"
	doman "${S}/doc/zerotier-"{cli.1,idtool.1,one.8}
}
