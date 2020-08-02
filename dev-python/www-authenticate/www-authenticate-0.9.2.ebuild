# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python3_{6,7,8} )
inherit distutils-r1

DESCRIPTION="WWW-Authenticate header parser"
HOMEPAGE="https://github.com/alexsdutton/www-authenticate"
SRC_URI="https://github.com/alexsdutton/www-authenticate/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64"

distutils_enable_tests nose
