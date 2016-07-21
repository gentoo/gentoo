# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit elisp versionator

MY_PN=${PN/-el/.el}
MY_BR=$(get_version_component_range 1-2)
DESCRIPTION="a SCIM-Bridge client for Emacs"
HOMEPAGE="https://launchpad.net/scim-bridge.el"
SRC_URI="https://launchpad.net/${MY_PN}/${MY_BR}/${PV}/+download/${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"
IUSE=""

DEPEND=""
RDEPEND="app-i18n/scim"

src_prepare () {
	epatch "${FILESDIR}"/${PN}-0.8.2-im-agent.patch
}
