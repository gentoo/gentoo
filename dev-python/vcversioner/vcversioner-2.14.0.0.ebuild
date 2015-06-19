# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/vcversioner/vcversioner-2.14.0.0.ebuild,v 1.1 2015/01/06 01:51:01 mrueg Exp $

EAPI=5

PYTHON_COMPAT=( python{2_7,3_3,3_4} )

inherit distutils-r1

DESCRIPTION="Use version control tags to discover version numbers"
HOMEPAGE="https://github.com/habnabit/vcversioner"
SRC_URI="mirror://pypi/v/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
