# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

[[ "${PV}" == 0.17 ]] && COMMIT="0147cabd8e82e46af27aef07aeed402b0bb9a0fb"

inherit elisp

DESCRIPTION="OAuth 2.0 authorization protocol"
HOMEPAGE="https://elpa.gnu.org/packages/oauth2.html"
SRC_URI="https://git.savannah.gnu.org/gitweb/?p=emacs/elpa.git;a=snapshot;h=${COMMIT};sf=tgz
	-> ${P}.tar.gz"
S="${WORKDIR}/elpa-${COMMIT:0:7}"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~alpha amd64 ppc ~ppc64 ~sparc x86"

DOCS=( NEWS )
SITEFILE="50${PN}-gentoo.el"
