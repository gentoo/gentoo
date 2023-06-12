# Copyright 2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

NEED_EMACS=26.1
inherit elisp

DESCRIPTION="Conveniently define themes for GNU Emacs"
HOMEPAGE="https://github.com/jasonm23/autothemer"

# Recompressed from NonGNU ELPA.
SRC_URI="https://dev.gentoo.org/~arsen/${P}.tar.xz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	>=app-emacs/dash-2.10.0
"
DEPEND="${RDEPEND}"

ELISP_REMOVE="${PN}-pkg.el"
SITEFILE="50${PN}-gentoo.el"

DOCS=(
	README.md
	CONTRIBUTING.md
	function-reference.md
)

elisp-enable-tests ert "${S}"/tests -l "${PN}"-tests.el
