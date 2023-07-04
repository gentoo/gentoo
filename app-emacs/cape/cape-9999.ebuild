# Copyright 2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

NEED_EMACS=27.1
inherit elisp

DESCRIPTION="Completion At Point Extensions"
HOMEPAGE="https://github.com/minad/cape"

if [[ ${PV} == 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/minad/cape.git"
else
	# Recompressed from ELPA.
	SRC_URI="https://dev.gentoo.org/~arsen/${P}.tar.xz"
	KEYWORDS="~amd64"
	ELISP_REMOVE="${PN}-pkg.el"
fi

LICENSE="GPL-3+"
SLOT="0"

RDEPEND="
	>=app-emacs/compat-29.1.4.0
"
DEPEND="${RDEPEND}"

SITEFILE="50${PN}-gentoo.el"

src_install() {
	elisp-make-autoload-file
	elisp_src_install

	if [[ ${PV} != 9999 ]]; then
		doinfo cape.info
	fi
}
