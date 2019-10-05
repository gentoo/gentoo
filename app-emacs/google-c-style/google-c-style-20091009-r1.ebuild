# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=4

inherit elisp

DESCRIPTION="Provides the google C/C++ coding style"
HOMEPAGE="https://github.com/google/styleguide"
SRC_URI="mirror://gentoo/${P}.tar.bz2"

LICENSE="|| ( GPL-1+ Artistic )"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

S="${WORKDIR}"
SITEFILE="50${PN}-gentoo.el"

pkg_postinst() {
	elisp-site-regen

	elog "Example usage (~/.emacs):"
	elog "  (add-hook 'c-mode-common-hook 'google-set-c-style)"
	elog "  (add-hook 'c-mode-common-hook 'google-make-newline-indent)"
}
