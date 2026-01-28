# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

COMMIT=78fc53feaf77a98d63894cd410faee2a18107b00

inherit elisp

DESCRIPTION="Common step definitions for Emacs Ecukes"
HOMEPAGE="https://github.com/ecukes/espuds/"
SRC_URI="https://github.com/ecukes/${PN}/archive/${COMMIT}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}"/${PN}-${COMMIT}

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~loong ppc64 ~riscv ~sparc x86"
RESTRICT="test"  # Tests fail

RDEPEND="
	app-emacs/dash
	app-emacs/f
	app-emacs/s
"
BDEPEND="${RDEPEND}"

DOCS=( README.md )
SITEFILE="50${PN}-gentoo.el"
