# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

NEED_EMACS=26.1

inherit elisp

DESCRIPTION="Child Frame Read String, alternative to read-string"
HOMEPAGE="https://github.com/Alexander-Miller/cfrs/"
SRC_URI="https://github.com/Alexander-Miller/${PN}/archive/${PV}.tar.gz
			-> ${P}.tar.gz"

LICENSE="GPL-3+"
KEYWORDS="~amd64 ~x86"
SLOT="0"

RDEPEND="
	app-emacs/dash
	app-emacs/posframe
	app-emacs/s
"
BDEPEND="${RDEPEND}"

DOCS=( README.org cfrs.png )
SITEFILE="50${PN}-gentoo.el"
