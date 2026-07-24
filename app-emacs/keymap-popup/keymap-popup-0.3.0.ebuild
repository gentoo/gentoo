# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=9
NEED_EMACS="29.1"

inherit elisp

DESCRIPTION="Described keymaps with popup help"
HOMEPAGE="https://codeberg.org/thanosapollo/emacs-keymap-popup"
SRC_URI="https://codeberg.org/thanosapollo/emacs-${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/emacs-${PN}"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64"

SITEFILE="50${PN}-gentoo.el"
DOCS="README.org docs/keymap-popup.org"

elisp-enable-tests ert tests -l ${PN}-tests.el
