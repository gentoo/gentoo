# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit elisp

DESCRIPTION="Test coverage library for Emacs"
HOMEPAGE="https://github.com/undercover-el/undercover.el/"
SRC_URI="https://github.com/undercover-el/${PN}.el/archive/v${PV}.tar.gz
			-> ${P}.tar.gz"
S="${WORKDIR}"/${PN}.el-${PV}

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~loong ppc64 ~riscv ~sparc x86"
RESTRICT="test"  # Tests fail

RDEPEND="
	app-emacs/dash
	app-emacs/shut-up
"
BDEPEND="${RDEPEND}"

DOCS=( README.md )
SITEFILE="50${PN}-gentoo.el"
