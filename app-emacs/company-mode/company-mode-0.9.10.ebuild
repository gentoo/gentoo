# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit elisp

DESCRIPTION="In-buffer completion front-end"
HOMEPAGE="https://company-mode.github.com/"
SRC_URI="https://github.com/${PN}/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
RESTRICT="test"

# Note: company-mode supports many backends, and we refrain
# from including them in RDEPEND.

SITEFILE="50${PN}-gentoo.el"
DOCS="README.md NEWS.md"
