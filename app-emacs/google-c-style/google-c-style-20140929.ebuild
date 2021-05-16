# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit elisp readme.gentoo-r1

DESCRIPTION="Provides the google C/C++ coding style"
HOMEPAGE="https://github.com/google/styleguide"
SRC_URI="https://dev.gentoo.org/~ulm/distfiles/${P}.el.gz"

LICENSE="|| ( GPL-1+ Artistic )"
SLOT="0"
KEYWORDS="amd64 x86"

S="${WORKDIR}"
SITEFILE="50${PN}-gentoo.el"
DOC_CONTENTS="Example usage (~/.emacs):
	\n\t(add-hook 'c-mode-common-hook 'google-set-c-style)
	\n\t(add-hook 'c-mode-common-hook 'google-make-newline-indent)"
