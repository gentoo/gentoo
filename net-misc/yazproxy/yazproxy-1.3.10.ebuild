# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="Z3950 proxy"
HOMEPAGE="https://www.indexdata.com/resources/software/yazproxy"
SRC_URI="http://ftp.indexdata.dk/pub/yazproxy/yazproxy-1.3.10.tar.gz"

LICENSE=""
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="dev-libs/yazpp"
RDEPEND="${DEPEND}"
