# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

NEED_EMACS="27.1"

inherit elisp

DESCRIPTION="Emacs X Window Manager"
HOMEPAGE="https://github.com/emacs-exwm/exwm/"

if [[ "${PV}" == *9999* ]] ; then
	inherit git-r3

	EGIT_REPO_URI="https://github.com/emacs-exwm/${PN}.git"
else
	SRC_URI="https://github.com/emacs-exwm/${PN}/archive/${PV}.tar.gz
		-> ${P}.tar.gz"

	KEYWORDS="~amd64 ~x86"
fi

LICENSE="GPL-3+"
SLOT="0"

BDEPEND="
	>=app-emacs/compat-30.0.0.0
	app-emacs/xelb
"
RDEPEND="
	${BDEPEND}
	x11-apps/xrandr
"

DOCS=( README.md )
SITEFILE="50${PN}-gentoo.el"

src_install() {
	elisp_src_install

	insinto "${SITEETC}/${PN}/examples"
	doins xinitrc
}
