# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/cityhash/cityhash-1.1.1.ebuild,v 1.1 2013/06/25 05:16:42 patrick Exp $
EAPI=4

DESCRIPTION="Google's CityHash family of hash functions"

HOMEPAGE="http://code.google.com/p/cityhash/"
SRC_URI="http://${PN}.googlecode.com/files/${P}.tar.gz"
LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64"

IUSE=""
#IUSE="sse42" should be added by someone with a modern CPU

DEPEND=""
RDEPEND="${DEPEND}"
