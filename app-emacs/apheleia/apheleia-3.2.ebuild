# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

NEED_EMACS=26

inherit elisp

DESCRIPTION="Reformat GNU Emacs buffers stably without moving point"
HOMEPAGE="https://github.com/radian-software/apheleia/"
SRC_URI="https://github.com/radian-software/${PN}/archive/v${PV}.tar.gz
	-> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DOCS=( README.md CHANGELOG.md )
SITEFILE="50${PN}-gentoo.el"
