# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-analyzer/ostinato/ostinato-0.5.1.ebuild,v 1.7 2014/01/23 14:06:16 zerochaos Exp $

EAPI=5
inherit qt4-r2

DESCRIPTION="A packet generator and analyzer"
HOMEPAGE="http://code.google.com/p/ostinato/"
SRC_URI="http://ostinato.googlecode.com/files/${PN}-src-${PV}.tar.gz"

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
