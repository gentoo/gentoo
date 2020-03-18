# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="protects hosts from brute force attacks against ssh"
HOMEPAGE="https://www.sshguard.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ~arm x86"

DEPEND="
	sys-devel/flex
"
RDEPEND="
	virtual/logger
"
DOCS=(
	CHANGELOG.rst
	CONTRIBUTING.rst
	README.rst
	examples/net.sshguard.plist
	examples/sshguard.service
	examples/whitelistfile.example
)
PATCHES=(
	"${FILESDIR}"/${PN}-2.1.0-conf.patch
)

src_install() {
	default

	newinitd "${FILESDIR}"/${PN}.initd-r2 ${PN}
	newconfd "${FILESDIR}"/${PN}.confd ${PN}

	insinto /etc
	newins examples/sshguard.conf.sample sshguard.conf
}
