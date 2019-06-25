# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit elisp

MY_P="${PN}-${PV#*_p}"
DESCRIPTION="Message citation utilities for emacsen"
HOMEPAGE="https://www.jpl.org/elips/mu/"
SRC_URI="https://www.jpl.org/elips/mu/snapshots/${MY_P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="bbdb"

RDEPEND="app-emacs/apel
	app-emacs/flim
	bbdb? ( app-emacs/bbdb )"
DEPEND="${RDEPEND}"

S="${WORKDIR}/${MY_P}"
SITEFILE="50${PN}-gentoo.el"
DOCS="ChangeLog NEWS README.en"

src_prepare() {
	elisp_src_prepare
	use bbdb || rm mu-bbdb.el || die
}
