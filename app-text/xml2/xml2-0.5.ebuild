# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4

DESCRIPTION="These tools are used to convert XML and HTML to and from a line-oriented format"
HOMEPAGE="http://dan.egnor.name/xml2"
SRC_URI="http://download.ofb.net/gale/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~x86-linux ~ppc-macos"
IUSE=""

RDEPEND="dev-libs/libxml2"
DEPEND="${RDEPEND}
	virtual/pkgconfig"
