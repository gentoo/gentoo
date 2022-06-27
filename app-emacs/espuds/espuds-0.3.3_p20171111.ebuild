# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

H=78fc53feaf77a98d63894cd410faee2a18107b00

inherit elisp

DESCRIPTION="Common step definitions for Emacs Ecukes"
HOMEPAGE="https://github.com/ecukes/espuds/"
SRC_URI="https://github.com/ecukes/${PN}/archive/${H}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}"/${PN}-${H}

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
RESTRICT="test"  # Tests fail

RDEPEND="
	app-emacs/dash
	app-emacs/f
	app-emacs/s
"
BDEPEND="${RDEPEND}"

DOCS=( README.md )
SITEFILE="50${PN}-gentoo.el"
