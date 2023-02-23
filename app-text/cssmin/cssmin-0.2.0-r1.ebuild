# Copyright 2021-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{9..11} )
inherit distutils-r1 pypi

DESCRIPTION="Python port of the YUI CSS compression algorithm"
HOMEPAGE="https://pypi.org/project/cssmin/ https://github.com/zacharyvoase/cssmin"

LICENSE="MIT BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
