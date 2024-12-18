# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# NOTICE: This package provides all "use-package" Emacs Lisp libraries except
# "bind-chord" and "bind-key" which are split into their own packages.

EAPI=8

inherit elisp

DESCRIPTION="Declaration macro for simplifying your Emacs configuration"
HOMEPAGE="https://github.com/jwiegley/use-package/
	https://elpa.gnu.org/packages/use-package.html"
SRC_URI="https://dev.gentoo.org/~xgqt/distfiles/repackaged/${P}.tar.xz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="amd64 ~arm ~arm64 ~hppa ~ppc ~ppc64 ~riscv ~sparc x86"

RDEPEND="
	app-emacs/bind-chord
	app-emacs/bind-key
	app-emacs/diminish
	app-emacs/system-packages
"
BDEPEND="
	${RDEPEND}
"

PATCHES=( "${FILESDIR}/${PN}-require-diminish.patch" )

SITEFILE="50${PN}-gentoo.el"
