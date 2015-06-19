# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/cgroup-utils/cgroup-utils-0.6.ebuild,v 1.1 2015/06/07 01:19:53 blueness Exp $

EAPI="5"
PYTHON_COMPAT=( python{2_7,3_3,3_4} )

inherit distutils-r1

DESCRIPTION="Tools and libraries for control groups of Linux"
HOMEPAGE="https://github.com/peo3/cgroup-utils"
SRC_URI="https://github.com/peo3/cgroup-utils/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"
RDEPEND=""
