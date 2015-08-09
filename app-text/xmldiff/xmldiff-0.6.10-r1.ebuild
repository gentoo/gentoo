# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

DESCRIPTION="A tool that figures out the differences between two similar XML files"
HOMEPAGE="http://www.logilab.org/project/xmldiff"
SRC_URI="ftp://ftp.logilab.fr/pub/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~ia64 ~ppc ~sparc ~x86 ~x86-linux"
IUSE=""

DEPEND="dev-python/pyxml[${PYTHON_USEDEP}]"
RDEPEND="${DEPEND}"

DOCS=( ChangeLog README README.xmlrev TODO )
