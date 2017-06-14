# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

if [[ ${PV} != *9999* ]]; then
	SRC_URI="https://github.com/darkk/${PN}/archive/release-${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~x86"
else
	GIT_ECLASS="git-r3"
	EGIT_REPO_URI="git://github.com/darkk/${PN}.git"
fi

inherit toolchain-funcs ${GIT_ECLASS}

DESCRIPTION="Transparent redirector of any TCP connection to proxy"
HOMEPAGE="http://darkk.net.ru/redsocks/"
LICENSE="Apache-2.0 LGPL-2.1+ ZLIB"
SLOT="0"
IUSE="doc"

DEPEND="dev-libs/libevent:0="
RDEPEND="${DEPEND}
	net-firewall/iptables"

[[ ${PV} != *9999 ]] && S="${WORKDIR}"/"${PN}"-release-"${PV}"

src_compile() {
	CC="$(tc-getCC)" emake || die "emake failed"
}

src_install() {
	dobin redsocks
	use doc && dodoc README doc/*
	insinto /etc/redsocks
	newins redsocks.conf.example redsocks.conf
}
