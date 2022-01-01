# Copyright 2020-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{8..10} )
inherit distutils-r1

DESCRIPTION="An strace-like tool for Python audit events"
HOMEPAGE="https://github.com/dcoles/snaketrace https://pypi.org/project/snaketrace/"
SRC_URI="https://github.com/dcoles/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"

distutils_enable_tests unittest
