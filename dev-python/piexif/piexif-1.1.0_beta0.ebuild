# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( pypy3 python{2_7,3_6} )

inherit distutils-r1

MY_P=${PN}-${PV/_beta/b}
DESCRIPTION="Exif manipulation with pure Python"
HOMEPAGE="https://github.com/hMatoba/Piexif
	https://pypi.org/project/piexif/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${MY_P}.zip"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"
RESTRICT="!test? ( test )"

S="${WORKDIR}"/${MY_P}

DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]
	app-arch/unzip
	test? ( dev-python/pillow )"

python_test() {
	"${PYTHON}" setup.py test
}
