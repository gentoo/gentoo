# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PN_F=${PN}
PV_F=v${PV}
MY_P=${PN}-v${PV}

DESCRIPTION="Internet platforms for proposition development and decision making"
HOMEPAGE="https://www.public-software-group.org/liquid_feedback"
SRC_URI="https://www.public-software-group.org/pub/projects/liquid_feedback/frontend/v${PV}/${MY_P}.tar.gz
	https://dev.gentoo.org/~tupone/distfiles/${MY_P}.tar.gz"

S="${WORKDIR}"/${MY_P}

LICENSE="HPND CC-BY-2.5"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="~www-apps/liquid_feedback_core-4.2.2
	~www-servers/moonbridge-1.1.3
	>=www-apps/webmcp-2.2.1"
DEPEND="${RDEPEND}"

DOCS=( INSTALL.html INSTALL.mkd )

src_install() {
	default

	insinto /var/lib/${PN}
	doins -r app db env fastpath lib locale model static style tmp
	fowners apache:apache /var/lib/${PN}/tmp

	insinto /etc/${PN}
	doins config/*
	dosym ../../../etc/${PN} /var/lib/${PN}/config

	newinitd "${FILESDIR}"/${PN}.initd ${PN}
}
