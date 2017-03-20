# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit common-lisp-3

if [[ ${PV} == 9999* ]] ; then
	inherit git-r3
	EGIT_REPO_URI="git://github.com/stumpwm/${PN}"
else
	SRC_URI="https://dev.gentoo.org/~nimiux/${CATEGORY}/${PN}/${P}.tar.bz2"
	KEYWORDS="~amd64 ~x86"
fi

DESCRIPTION="Extension Modules for StumpWM"
HOMEPAGE="https://github.com/stumpwm/stumpwm-contrib/"

LICENSE="GPL-2 GPL-3 BSD-2"
SLOT="0"
IUSE=""

RDEPEND=">=x11-wm/stumpwm-0.9.9"

CONTRIBCATEGORIES="media modeline minor-mode util"

src_install() {
	common-lisp-install-sources -t all ${CONTRIBCATEGORIES}
	dobin util/stumpish/stumpish
	dodoc README.org
}
