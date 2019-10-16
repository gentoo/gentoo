# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit elisp

COMMIT="9ee0854446dcc6c53d2b8d2941051768dba50344"
DESCRIPTION="Emacs major mode for devicetree sources"
HOMEPAGE="https://github.com/bgamari/dts-mode"
SRC_URI="https://github.com/bgamari/${PN}/archive/${COMMIT}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~x86"

S="${WORKDIR}/${PN}-${COMMIT}"
SITEFILE="50${PN}-gentoo.el"
DOCS="README.mkd"
