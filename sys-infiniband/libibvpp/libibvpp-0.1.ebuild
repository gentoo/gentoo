# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-infiniband/libibvpp/libibvpp-0.1.ebuild,v 1.5 2014/08/10 20:18:59 slyfox Exp $

EAPI=4

DESCRIPTION="C++ wrapper around libibverbs, which is part of OpenIB"
HOMEPAGE="http://ti.arc.nasa.gov/opensource/projects/libibvpp/"
SRC_URI="http://ti.arc.nasa.gov/m/opensource/downloads/${P}.tar.gz"

LICENSE="NOSA BSD-2"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux"
IUSE=""

DEPEND="
	sys-infiniband/libibverbs"
RDEPEND="${DEPEND}"
