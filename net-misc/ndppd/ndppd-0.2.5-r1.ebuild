# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Proxies NDP messages between interfaces"
HOMEPAGE="https://github.com/DanielAdolfsson/ndppd"
SRC_URI="https://github.com/DanielAdolfsson/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"

src_install() {
	dosbin ${PN}
	doman ${PN}.{1,conf.5}
	insinto /etc
	newins ndppd.conf-dist ndppd.conf
	newinitd "${FILESDIR}"/ndppd.initd ndppd
}
