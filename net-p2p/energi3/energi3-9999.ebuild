# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit go-module systemd

DESCRIPTION="Official golang implementation of the Energi Core"
HOMEPAGE="https://www.energi.world/"

if [[ ${PV} == *9999 ]] ; then
	EGIT_REPO_URI="https://github.com/energicryptocurrency/${PN}.git"
	EGIT_SUBMODULES=()
	inherit git-r3
else
	SRC_URI="https://github.com/energicryptocurrency/${PN}/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64"
fi

LICENSE="GPL-3 LGPL-3"
SLOT="0"

RDEPEND="acct-user/energi3"

# Does all kinds of wonky stuff like connecting to Docker daemon, network activity, ...
RESTRICT+=" test"

src_compile() {
	GOPATH="${WORKDIR}/${P}/vendor/" emake geth
}

src_install() {
	einstalldocs
	dobin build/bin/energi3
	systemd_dounit "${FILESDIR}/energi3.service"
}

pkg_postinst() {
	elog "Run the service:       systemctl start energi3"
	elog "Attach to the service: energi3 attach --datadir /var/lib/energi3/"
	elog "The user attaching must be a member of the 'energi3' group"
}
