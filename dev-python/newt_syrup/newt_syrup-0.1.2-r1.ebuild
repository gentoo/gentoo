# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

DESCRIPTION="A Python framework for creating text-based applications"
HOMEPAGE="http://fedorahosted.org/newt-syrup/"
SRC_URI="http://mcpierce.fedorapeople.org/rpms/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"
RDEPEND=">=dev-libs/newt-0.52.11"

DOCS="COLORS"
