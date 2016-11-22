# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

PYTHON_COMPAT=( python{2_7,3_4} )

inherit distutils-r1

DESCRIPTION="A Python script for summarizing gcov data"
HOMEPAGE="https://github.com/gcovr/gcovr"
LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
SRC_URI="https://github.com/gcovr/gcovr/archive/${PV}.tar.gz -> ${P}.tar.gz"
