# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit elisp

DESCRIPTION="Lists of Unicode mathematical symbols and latex commands"
HOMEPAGE="https://github.com/vspinu/math-symbol-lists/"
SRC_URI="https://github.com/vspinu/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="amd64 ~x86"

DOCS=( readme.md )
SITEFILE="50${PN}-gentoo.el"
