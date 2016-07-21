# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

DESCRIPTION="Enhanced internationalization (I18N) services for your Python modules and applications"
HOMEPAGE="https://github.com/dieterv/elib.intl/"
SRC_URI="mirror://gentoo/${P}.tar.gz"

KEYWORDS="amd64 x86"
LICENSE="GPL-3 LGPL-3"
SLOT="0"
IUSE=""

RDEPEND=""
DEPEND="dev-python/setuptools
	${RDEPEND}"
