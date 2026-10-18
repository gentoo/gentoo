# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=9

NEED_EMACS="27.1"

inherit elisp

DESCRIPTION="Practical and friendly Gopher and Gemini client for GNU Emacs"
HOMEPAGE="https://thelambdalab.xyz/elpher/
	https://elpa.nongnu.org/nongnu/elpher.html"

if [[ "${PV}" == *9999* ]] ; then
	inherit git-r3
	EGIT_REPO_URI="git://thelambdalab.xyz/${PN}.git"
else
	SRC_URI="https://dev.gentoo.org/~xgqt/distfiles/mirrored/${P}.tar.xz"
	KEYWORDS="~amd64 ~x86"
fi

LICENSE="GPL-3+"
SLOT="0"

ELISP_REMOVE="
	elpher-pkg.el
"
DOCS=( README )
ELISP_TEXINFO="${PN}.texi"
SITEFILE="50${PN}-gentoo.el"
