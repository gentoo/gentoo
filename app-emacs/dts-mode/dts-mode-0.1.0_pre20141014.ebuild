# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-emacs/dts-mode/dts-mode-0.1.0_pre20141014.ebuild,v 1.1 2015/01/03 16:24:33 ulm Exp $

EAPI=5

inherit elisp

DESCRIPTION="Emacs major mode for devicetree sources"
HOMEPAGE="https://github.com/bgamari/dts-mode"
SRC_URI="http://dev.gentoo.org/~ulm/distfiles/${P}.tar.xz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~x86"

S="${WORKDIR}/${PN}"
SITEFILE="50${PN}-gentoo.el"
DOCS="README.mkd"
