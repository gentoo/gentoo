# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-emacs/yaml-mode/yaml-mode-0.0.8.ebuild,v 1.4 2013/10/03 14:02:08 ulm Exp $

EAPI=4

inherit elisp

DESCRIPTION="A major mode for GNU Emacs for editing YAML files"
HOMEPAGE="https://github.com/yoshiki/yaml-mode"
SRC_URI="mirror://github/yoshiki/${PN}/${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DOCS="README Changes"
SITEFILE="50${PN}-gentoo.el"
