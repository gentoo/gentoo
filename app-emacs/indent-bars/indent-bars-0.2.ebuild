# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
NEED_EMACS=27.1

inherit elisp

IUSE=""

DESCRIPTION="Fast, configurable indentation guide-bars for Emacs"
HOMEPAGE="https://github.com/jdtsmith/indent-bars"
SRC_URI="https://github.com/jdtsmith/indent-bars/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"

SITEFILE="50${PN}-gentoo.el"

DOCS="examples.md README.md"
