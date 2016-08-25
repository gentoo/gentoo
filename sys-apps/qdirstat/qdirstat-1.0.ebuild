# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit qmake-utils

DESCRIPTION="Qt app to show where your disk space has gone and to help you clean it up"
HOMEPAGE="https://github.com/shundhammer/qdirstat"
SRC_URI="https://github.com/shundhammer/qdirstat/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="
	dev-qt/qtgui:5
	dev-qt/qtcore:5
	dev-qt/qtwidgets:5"

RDEPEND="${DEPEND}"

src_configure() {
	eqmake5
}

src_install() {
	emake INSTALL_ROOT="${ED}" install
}
