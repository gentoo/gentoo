# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit cmake-utils

DESCRIPTION="FTP server with a service discovery feature"
HOMEPAGE="http://www.zuzuf.net/qshare/"
SRC_URI="http://www.zuzuf.net/qshare/files/${P}-src.tar.bz2"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

RDEPEND="dev-qt/qtcore:4
	dev-qt/qtgui:4
	net-dns/avahi[mdnsresponder-compat]"
DEPEND="${RDEPEND}"

DOCS=( AUTHORS README )
PATCHES=( "${FILESDIR}/${P}-desktop.patch" )
