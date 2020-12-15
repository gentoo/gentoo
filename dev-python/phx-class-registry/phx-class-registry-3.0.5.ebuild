# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7..9} pypy3 )
inherit distutils-r1

DESCRIPTION="An intersection of the Registry and Factory pattern"
HOMEPAGE="https://github.com/todofixthis/class-registry"
SRC_URI="https://github.com/todofixthis/class-registry/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
S="${WORKDIR}/class-registry-${PV}"

distutils_enable_tests nose
