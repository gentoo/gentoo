# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-misc/asciinema/asciinema-0.9.8.ebuild,v 1.3 2014/11/24 12:22:50 kensington Exp $

EAPI=5

PYTHON_COMPAT=( python{2_7,3_3,3_4})
inherit distutils-r1

DESCRIPTION="Command line recorder for asciinema.org service"
HOMEPAGE="http://pypi.python.org/pypi/asciinema http://asciinema.org/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64"
IUSE=""

DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"
RDEPEND=">=dev-python/requests-1.1.0[${PYTHON_USEDEP}]"
