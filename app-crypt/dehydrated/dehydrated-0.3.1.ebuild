# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

DESCRIPTION="a client for signing certificates with an ACME-server"
HOMEPAGE="https://github.com/lukas2511/dehydrated"
SRC_URI="https://github.com/lukas2511/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="app-shells/bash"

src_install() {
	dobin dehydrated
	insinto "/etc/${PN}"
	doins docs/examples/{config,domains.txt,hook.sh}
	dodoc docs/*.md
	default

}
