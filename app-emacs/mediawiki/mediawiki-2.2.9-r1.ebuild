# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit elisp

MY_PN="${PN}-el"
DESCRIPTION="MediaWiki client for Emacs"
HOMEPAGE="https://github.com/hexmode/mediawiki-el"
SRC_URI="https://github.com/hexmode/${MY_PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~x86"

S="${WORKDIR}/${MY_PN}-${PV}"
ELISP_PATCHES="${P}-user-agent.patch"
SITEFILE="50${PN}-gentoo-${PV}.el"
DOCS="README.mediawiki"
