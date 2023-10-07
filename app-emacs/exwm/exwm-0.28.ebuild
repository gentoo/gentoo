# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit elisp

DESCRIPTION="Emacs X Window Manager"
HOMEPAGE="https://github.com/ch11ng/exwm/"
SRC_URI="https://github.com/ch11ng/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~x86"

BDEPEND="app-emacs/xelb"
RDEPEND="
	${BDEPEND}
	x11-apps/xrandr
"

DOCS=( README.md )
SITEFILE="50${PN}-gentoo.el"

src_install() {
	elisp_src_install

	insinto ${SITEETC}/${PN}/examples
	doins xinitrc
}
