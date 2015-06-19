# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-cpp/metslib/metslib-0.5.3.ebuild,v 1.3 2014/10/31 14:09:06 aballier Exp $

EAPI=5

DESCRIPTION="Metaheuristic modeling framework and optimization toolkit"
HOMEPAGE="https://projects.coin-or.org/metslib"
SRC_URI="http://www.coin-or.org/download/source/metslib/${P}.tgz"

LICENSE="|| ( GPL-3 CPL-1.0 )"
SLOT="0"
KEYWORDS="~amd64 ~arm"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"
DOCS=( AUTHORS NEWS README )
