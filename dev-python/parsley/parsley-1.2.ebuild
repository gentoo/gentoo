# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/parsley/parsley-1.2.ebuild,v 1.1 2015/01/05 21:27:16 mrueg Exp $

EAPI=5

PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

DESCRIPTION="A Pattern-Matching Language Based on OMeta and Python"
HOMEPAGE="https://github.com/python-parsley/parsley"
SRC_URI="https://github.com/python-${PN}/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
