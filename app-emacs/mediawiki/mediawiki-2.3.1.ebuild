# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit elisp

MY_PN="${PN}-el"
DESCRIPTION="MediaWiki client for Emacs"
HOMEPAGE="https://github.com/hexmode/mediawiki-el"
SRC_URI="https://github.com/hexmode/${MY_PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${MY_PN}-${PV}"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~x86"

SITEFILE="50${PN}-gentoo-2.2.9.el"
DOCS="README.mediawiki"
