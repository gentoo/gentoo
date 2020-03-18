# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

if [[ ${PV} != *9999* ]]; then
	SRC_URI="https://github.com/darkk/${PN}/archive/release-${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~x86"
else
	GIT_ECLASS="git-r3"
	EGIT_REPO_URI="https://github.com/darkk/${PN}.git"
fi

inherit systemd toolchain-funcs user ${GIT_ECLASS}

DESCRIPTION="Transparent redirector of any TCP connection to proxy"
HOMEPAGE="http://darkk.net.ru/redsocks/"
LICENSE="Apache-2.0 LGPL-2.1+ ZLIB"
SLOT="0"
IUSE="doc"
RESTRICT="test"

DEPEND="dev-libs/libevent:0="
RDEPEND="${DEPEND}
	net-firewall/iptables"

[[ ${PV} != *9999 ]] && S="${WORKDIR}"/"${PN}"-release-"${PV}"

pkg_setup() {
	enewgroup redsocks
	enewuser redsocks -1 -1 /run/redsocks redsocks
}

src_compile() {
	CC="$(tc-getCC)" emake
}

src_install() {
	dosbin redsocks
	doman debian/redsocks.8
	use doc && dodoc README doc/*
	insinto /etc
	newins debian/redsocks.conf redsocks.conf

	newinitd "${FILESDIR}"/redsocks.init redsocks
	newconfd "${FILESDIR}"/redsocks.conf redsocks

	systemd_dounit "${FILESDIR}"/redsocks.service
}
