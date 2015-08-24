# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$
EAPI=4

DESCRIPTION="Google's CityHash family of hash functions"

HOMEPAGE="https://code.google.com/p/cityhash/"
SRC_URI="https://${PN}.googlecode.com/files/${P}.tar.gz"
LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64"

IUSE=""
#IUSE="sse42" should be added by someone with a modern CPU

DEPEND=""
RDEPEND="${DEPEND}"
