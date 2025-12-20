# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="These tools are used to convert XML and HTML to and from a line-oriented format"
HOMEPAGE="http://dan.egnor.name/xml2"
SRC_URI="http://download.ofb.net/gale/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="dev-libs/libxml2:="
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"
