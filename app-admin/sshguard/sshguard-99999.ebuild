# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit autotools git-r3

DESCRIPTION="protects hosts from brute force attacks against ssh"
HOMEPAGE="https://www.sshguard.net/"
EGIT_REPO_URI="https://bitbucket.org/${PN}/${PN}"

LICENSE="BSD"
SLOT="0"
KEYWORDS=""

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

src_prepare() {
	default
	eautoreconf
}

src_install() {
	default

	newinitd "${FILESDIR}"/${PN}.initd-r2 ${PN}
	newconfd "${FILESDIR}"/${PN}.confd ${PN}

	insinto /etc
	newins examples/sshguard.conf.sample sshguard.conf
}
