# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit elisp

DESCRIPTION="EditorConfig plugin for emacs"
HOMEPAGE="https://github.com/editorconfig/${PN}/"
SRC_URI="https://github.com/editorconfig/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
RESTRICT="test"

src_install() {
	local site_file="${T}/50${PN}-gentoo.el"
	echo "
(require 'editorconfig)
(editorconfig-mode 1)
" > "${site_file}" || die
	elisp-site-file-install "${site_file}"
	elisp_src_install
	dodoc README.md
}
