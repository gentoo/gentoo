# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

PYTHON_COMPAT=(python{2_7,3_4,3_5,3_6})
inherit distutils-r1

DESCRIPTION="Automated Reasoning Engine and Flow Based Programming Framework"
HOMEPAGE="https://github.com/ioflo/ioflo/"
SRC_URI="https://github.com/${PN}/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]
	>=dev-python/setuptools-git-1.1[${PYTHON_USEDEP}]"
