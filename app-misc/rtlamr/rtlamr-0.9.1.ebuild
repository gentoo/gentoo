# Copyright 2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
EGO_PN=github.com/bemasher/rtlamr
inherit golang-build golang-vcs-snapshot

DESCRIPTION="software defined radio receiver for utility smart meters"
HOMEPAGE="https://github.com/bemasher/rtlamr"
SRC_URI="https://${EGO_PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="AGPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"

src_install() {
	dobin ${PN}
	dodoc src/${EGO_PN}/*.md src/${EGO_PN}/*.csv
}
