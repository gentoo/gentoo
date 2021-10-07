# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{8..10} )

inherit distutils-r1

DESCRIPTION="casttube provides a way to interact with the Youtube Chromecast api."
HOMEPAGE="https://github.com/ur1katz/casttube"
SRC_URI="mirror://pypi/${P:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="dev-python/requests[${PYTHON_USEDEP}]"

src_prepare() {
	sed -e '/data_files/d' -i setup.py || die
	distutils-r1_src_prepare
}
