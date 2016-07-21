# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

DESCRIPTION="a qt-based imhangul"
HOMEPAGE="https://code.google.com/p/qimhangul/"
SRC_URI="https://qimhangul.googlecode.com/files/${P}.tar.gz"

LICENSE="LGPL-3"
SLOT="0"
KEYWORDS="amd64"
IUSE=""

DEPEND=">=app-i18n/libhangul-0.0.12
	dev-qt/qtgui:4"
RDEPEND="${DEPEND}"
