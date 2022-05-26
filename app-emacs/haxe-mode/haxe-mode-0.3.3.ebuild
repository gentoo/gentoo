# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit elisp

DESCRIPTION="Major mode for editing Haxe files"
HOMEPAGE="https://github.com/emacsorphanage/haxe-mode/"
SRC_URI="https://github.com/emacsorphanage/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3+"
KEYWORDS="~amd64 ~x86"
SLOT="0"

DOCS=( README.md )
SITEFILE="50${PN}-gentoo.el"
