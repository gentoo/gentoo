# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

DESCRIPTION="Visual binary diff utility"
HOMEPAGE="http://www.cjmweb.net/vbindiff/"
SRC_URI="https://github.com/mrdudz/${PN}/releases/download/${PV}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86 ~x86-fbsd"
IUSE=""

RDEPEND="sys-libs/ncurses:0="
DEPEND="${RDEPEND}"
