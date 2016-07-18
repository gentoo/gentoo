# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

PYTHON_COMPAT=( python3_{3,4,5} )

inherit distutils-r1

DESCRIPTION="Library for managing Bugzilla bug reports from the CLI"
HOMEPAGE="https://github.com/monsieurp/libzilla"
SRC_URI="https://github.com/monsieurp/libzilla/archive/v${PV}.zip -> ${P}.zip"

KEYWORDS="~amd64 ~x86"
LICENSE="MIT"
SLOT="0"
IUSE=""

RDEPEND=""
DEPEND="${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]
	dev-python/docopt[${PYTHON_USEDEP}]
	dev-python/requests[${PYTHON_USEDEP}]"
