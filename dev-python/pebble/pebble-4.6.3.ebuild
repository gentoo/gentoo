# Copyright 2020-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..10} )
inherit distutils-r1

MY_P=${P^}
DESCRIPTION="Threading and multiprocessing eye-candy"
HOMEPAGE="
	https://pypi.org/project/Pebble/
	https://pebble.readthedocs.io/
	https://github.com/noxdafox/pebble"
SRC_URI="mirror://pypi/${MY_P::1}/${PN^}/${MY_P}.tar.gz"
S=${WORKDIR}/${P^}

LICENSE="LGPL-3+"
SLOT="0"
KEYWORDS="amd64 ~arm ~arm64 ~ia64 ~ppc ~ppc64 ~s390 ~sparc x86"

distutils_enable_tests pytest
