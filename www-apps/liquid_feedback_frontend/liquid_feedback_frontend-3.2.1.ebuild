# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

PN_F=${PN}
PV_F=v${PV}
MY_P=${PN}-v${PV}

DESCRIPTION="Internet platforms for proposition development and decision making"
HOMEPAGE="https://www.public-software-group.org/liquid_feedback"
SRC_URI="https://www.public-software-group.org/pub/projects/liquid_feedback/frontend/v${PV}/${MY_P}.tar.gz"

LICENSE="HPND CC-BY-2.5"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

RDEPEND="~www-apps/liquid_feedback_core-3.2.2
	~www-servers/moonbridge-1.0.1
	>=www-apps/webmcp-2.1.0
	acct-user/apache"
DEPEND="${RDEPEND}"

S="${WORKDIR}"/${MY_P}

DOCS=( INSTALL.html INSTALL.mkd )

src_install() {
	default

	insinto /var/lib/${PN}
	doins -r app db env fastpath lib locale model static tmp
	fowners apache:apache /var/lib/${PN}/tmp
	dodir /var/log/liquid_feedback
	keepdir /var/log/liquid_feedback
	fowners apache:apache /var/log/liquid_feedback

	insinto /etc/${PN}
	doins "${FILESDIR}"/myconfig-3.lua config/*
	dosym ../../../etc/${PN} /var/lib/${PN}/config

	newinitd "${FILESDIR}"/liquid_feedback.initd liquid_feedback
}
