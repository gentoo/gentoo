# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/nanomsg/nanomsg-0.4.ebuild,v 1.1 2014/06/11 05:54:32 djc Exp $

EAPI=5

DESCRIPTION="High-performance messaging interface for distributed applications"
HOMEPAGE="http://nanomsg.org/"
SRC_URI="http://download.nanomsg.org/${P}-beta.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"
IUSE=""

DEPEND=""
RDEPEND=""

S="${WORKDIR}/${P}-beta"
