# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( pypy3 python3_{7,8,9} )
inherit distutils-r1

DESCRIPTION="Sphinx Themes for Flask related projects and Flask itself"
HOMEPAGE="https://github.com/pallets/pallets-sphinx-themes https://pypi.org/project/Pallets-Sphinx-Themes"
SRC_URI="https://github.com/pallets/pallets-sphinx-themes/archive/${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/pallets-sphinx-themes-${PV}"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~x86"
