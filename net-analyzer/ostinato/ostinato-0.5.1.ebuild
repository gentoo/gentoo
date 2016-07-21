# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit qt4-r2

DESCRIPTION="A packet generator and analyzer"
HOMEPAGE="http://ostinato.org/"
SRC_URI="https://ostinato.googlecode.com/files/${PN}-src-${PV}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 arm x86"
IUSE=""

DEPEND="dev-libs/protobuf:=
	net-libs/libpcap
	dev-qt/qtcore:4
	dev-qt/qtgui:4
	dev-qt/qtscript:4"
RDEPEND="${DEPEND}"

src_configure(){
	eqmake4 PREFIX=/usr ost.pro
}
