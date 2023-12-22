# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit elisp

DESCRIPTION="OAuth 2.0 authorization protocol"
HOMEPAGE="https://elpa.gnu.org/packages/oauth2.html"
GITHUB_SHA1="dc069550616fb0a72507489ea796d0e1bd8b48c9"
SRC_URI="https://github.com/emacsmirror/${PN}/archive/${GITHUB_SHA1}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${PN}-${GITHUB_SHA1}"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~ia64 ~ppc ~ppc64 ~sparc ~x86"

SITEFILE="50${PN}-gentoo.el"
