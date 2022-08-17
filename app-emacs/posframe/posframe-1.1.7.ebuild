# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

NEED_EMACS=26.1

inherit elisp

DESCRIPTION="Pop up a frame at point"
HOMEPAGE="https://github.com/tumashu/posframe/"
SRC_URI="https://github.com/tumashu/${PN}/archive/refs/tags/v${PV}.tar.gz
			-> ${P}.tar.gz"

LICENSE="GPL-3+"
KEYWORDS="~amd64 ~x86"
SLOT="0"

DOCS=( README.org snapshots )
SITEFILE="50${PN}-gentoo.el"
