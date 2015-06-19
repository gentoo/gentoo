# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/nanomsg/nanomsg-0.5.ebuild,v 1.2 2015/01/19 11:22:22 pinkbyte Exp $

EAPI=5

DESCRIPTION="High-performance messaging interface for distributed applications"
HOMEPAGE="http://nanomsg.org/"
SRC_URI="http://download.nanomsg.org/${P}-beta.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~mips ~ppc ~ppc64 ~s390 ~x86"
IUSE=""

DEPEND=""
RDEPEND=""

S="${WORKDIR}/${P}-beta"
