# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_8 )
DISTUTILS_USE_SETUPTOOLS=rdepend
inherit distutils-r1

DESCRIPTION="Console CardDAV client"
HOMEPAGE="https://github.com/scheibler/khard"

LICENSE="GPL-3"
SLOT="0"

if [ "${PV}" == "9999" ]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/scheibler/khard"
else
	SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"
	KEYWORDS="amd64 ~arm ~arm64 ~x86"
fi

RDEPEND="
	dev-python/atomicwrites[${PYTHON_USEDEP}]
	dev-python/configobj[${PYTHON_USEDEP}]
	dev-python/ruamel-yaml[${PYTHON_USEDEP}]
	dev-python/unidecode[${PYTHON_USEDEP}]
	>dev-python/vobject-0.9.3[${PYTHON_USEDEP}]
"
# vobject-0.9.3 breaks khard, see
# https://github.com/scheibler/khard/issues/87
# https://github.com/eventable/vobject/issues/39

DOCS=( AUTHORS CHANGES README.md misc/khard/khard.conf.example )

distutils_enable_tests setup.py

src_install() {
	distutils-r1_src_install

	insinto /usr/share/zsh/site-functions
	doins misc/zsh/_khard
}
