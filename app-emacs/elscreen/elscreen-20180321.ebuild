# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit elisp

DESCRIPTION="Frame configuration management for GNU Emacs modelled after GNU Screen"
HOMEPAGE="https://www.emacswiki.org/emacs/EmacsLispScreen
	https://github.com/knu/elscreen"
SRC_URI="https://github.com/knu/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2+ GPL-3+"
SLOT="0"
KEYWORDS="~alpha amd64 hppa ~ia64 ~ppc ~ppc64 sparc x86"
IUSE="wanderlust"

RDEPEND="wanderlust? ( app-emacs/wanderlust )"
BDEPEND="${RDEPEND}"

SITEFILE="50${PN}-gentoo-${PV}.el"
ELISP_REMOVE="elscreen-dnd.el"	# does not compile
DOCS="Readme.md GF-README GF-QuickStart"

src_prepare() {
	elisp_src_prepare
	use wanderlust || rm elscreen-wl.el || die
}
