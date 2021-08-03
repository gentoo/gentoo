# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{8..10} )
inherit distutils-r1

DESCRIPTION="py.test plugin that allows you to add environment variables"
HOMEPAGE="https://github.com/MobileDynasty/pytest-env"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ~hppa ~ppc ~ppc64 ~x86"

RDEPEND="dev-python/pytest[${PYTHON_USEDEP}]"
