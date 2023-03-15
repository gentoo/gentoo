# Copyright 2021-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{9..11} )

inherit distutils-r1 pypi

DESCRIPTION="casttube provides a way to interact with the Youtube Chromecast api"
HOMEPAGE="https://github.com/ur1katz/casttube"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="dev-python/requests[${PYTHON_USEDEP}]"

src_prepare() {
	sed -e '/data_files/d' -i setup.py || die
	distutils-r1_src_prepare
}
