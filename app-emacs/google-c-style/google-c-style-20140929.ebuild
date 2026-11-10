# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit elisp readme.gentoo-r1

DESCRIPTION="Provides the google C/C++ coding style"
HOMEPAGE="https://github.com/google/styleguide"
SRC_URI="https://distfiles.gentoo.org/pub/proj/emacs/${P}.el.gz"
S="${WORKDIR}"

LICENSE="|| ( GPL-1+ Artistic )"
SLOT="0"
KEYWORDS="amd64 x86"

SITEFILE="50${PN}-gentoo.el"
DOC_CONTENTS="Example usage (~/.emacs):
	\n\t(add-hook 'c-mode-common-hook 'google-set-c-style)
	\n\t(add-hook 'c-mode-common-hook 'google-make-newline-indent)"
