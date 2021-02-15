# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools systemd
DESCRIPTION="protects hosts from brute force attacks against ssh"
HOMEPAGE="https://www.sshguard.net/"

if [[ "${PV}" == 99999 ]] ; then
	inherit git-r3
	EGIT_REPO_URI="https://bitbucket.org/${PN}/${PN}"
else
	SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"
	KEYWORDS="~amd64 ~arm ~arm64 ~x86"
fi

LICENSE="BSD"
SLOT="0"

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
	examples/whitelistfile.example
)

PATCHES=(
	"${FILESDIR}"/${PN}-2.4.1-conf.patch
)

src_prepare() {
	default
	sed -i -e "/ExecStartPre/s:/usr/sbin:/sbin:g" \
		-e "/ExecStart/s:/usr/local/sbin:/usr/sbin:g" \
		"${S}"/examples/${PN}.service || die
	eautoreconf
}

src_install() {
	default

	newinitd "${FILESDIR}"/${PN}.initd-r2 ${PN}
	newconfd "${FILESDIR}"/${PN}.confd ${PN}

	insinto /etc
	newins examples/sshguard.conf.sample sshguard.conf

	systemd_dounit "${S}"/examples/sshguard.service
}
