# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit elisp

MY_PN=${PN/-el/.el}
MY_BR=$(ver_cut 1-2)
DESCRIPTION="a SCIM-Bridge client for Emacs"
HOMEPAGE="https://launchpad.net/scim-bridge.el"
SRC_URI="https://launchpad.net/${MY_PN}/${MY_BR}/${PV}/+download/${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"

RDEPEND="app-i18n/scim"

PATCHES=("${FILESDIR}"/${PN}-0.8.2-im-agent.patch)
