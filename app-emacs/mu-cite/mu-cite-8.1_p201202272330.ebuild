# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit elisp

MY_P="${PN}-${PV#*_p}"
DESCRIPTION="Message citation utilities for emacsen"
HOMEPAGE="http://www.jpl.org/elips/mu/"
SRC_URI="http://www.jpl.org/elips/mu/snapshots/${MY_P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="app-emacs/apel
	app-emacs/flim"
DEPEND="${RDEPEND}"

SITEFILE="50${PN}-gentoo.el"
DOCS="ChangeLog NEWS README.en"

S="${WORKDIR}/${MY_P}"

src_compile() {
	emake EMACS=emacs
}
