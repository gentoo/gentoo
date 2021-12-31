# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{5..7} )

inherit distutils-r1

DESCRIPTION="File format determination library for Python"
HOMEPAGE="https://github.com/floyernick/fleep-py"

if [ "${PV}" = "9999" ]; then
	EGIT_REPO_URI="https://github.com/floyernick/fleep-py.git"
	inherit git-r3
else
	SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"
	KEYWORDS="~amd64 ~x86"
fi

LICENSE="MIT"
SLOT="0"
IUSE=""
