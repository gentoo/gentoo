# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit git-r3

DESCRIPTION="Tool to measure IP bandwidth using UDP or TCP"
HOMEPAGE="https://sourceforge.net/projects/iperf2/"
EGIT_REPO_URI="https://git.code.sf.net/p/iperf2/code"

LICENSE="HPND"
SLOT="2"
KEYWORDS=""
IUSE="ipv6 threads debug"

DOCS="INSTALL README"
PATCHES=(
	"${FILESDIR}"/${PN}-2.0.12-ipv6.patch
)

src_configure() {
	econf \
		$(use_enable debug debuginfo) \
		$(use_enable ipv6) \
		$(use_enable threads)
}

src_install() {
	default
	dodoc doc/*
	newinitd "${FILESDIR}"/${PN}.initd-r1 ${PN}
	newconfd "${FILESDIR}"/${PN}.confd ${PN}
}
