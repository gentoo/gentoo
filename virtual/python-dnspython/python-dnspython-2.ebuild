# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python{2_7,3_4,3_5,3_6} )

inherit python-r1

DESCRIPTION="A virtual for dnspython, for Python 2 & 3"
SLOT="0"
KEYWORDS="alpha amd64 ~arm ~arm64 hppa ~ia64 ~ppc ~ppc64 ~s390 ~sh sparc x86 ~amd64-linux ~x86-linux"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND=">=dev-python/dnspython-1.15.0:0[${PYTHON_USEDEP}]"
