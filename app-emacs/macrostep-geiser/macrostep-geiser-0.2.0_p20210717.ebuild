# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

COMMIT=f6a2d5bb96ade4f23df557649af87ebd0cc45125

inherit elisp

DESCRIPTION="Emacs macrostep back-end powered by geiser"
HOMEPAGE="https://github.com/nbfalcon/macrostep-geiser/"
SRC_URI="https://github.com/nbfalcon/${PN}/archive/${COMMIT}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}"/${PN}-${COMMIT}

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DOCS=( README.md )
SITEFILE="50${PN}-gentoo.el"

RDEPEND="
	app-emacs/geiser
	app-emacs/macrostep
"
BDEPEND="${RDEPEND}"
