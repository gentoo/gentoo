# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/mysql-connector-python/mysql-connector-python-2.1.1.ebuild,v 1.1 2015/04/08 06:59:20 idella4 Exp $

EAPI=5

PYTHON_COMPAT=( python{2_7,3_3,3_4} )
inherit distutils-r1

DESCRIPTION="Python client library for MariaDB/MySQL"
HOMEPAGE="https://dev.mysql.com/downloads/connector/python/"
SRC_URI="mirror://mysql/Downloads/Connector-Python/${P}.tar.gz"

KEYWORDS="~amd64 ~arm ~x86"
LICENSE="GPL-2"
SLOT="0"
IUSE="examples"

DOCS=( README.txt CHANGES.txt docs/README_DOCS.txt )

EXAMPLES=( examples/. )
