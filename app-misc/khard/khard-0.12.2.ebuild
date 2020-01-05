# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
PYTHON_COMPAT=( python3_6 )
inherit distutils-r1
DESCRIPTION="Console CardDAV client"
HOMEPAGE="https://github.com/scheibler/khard"
LICENSE="GPL-3"
SLOT="0"
IUSE="zsh-completion"

if [ "${PV}" == "9999" ]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/scheibler/khard"
else
	SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"
	KEYWORDS="amd64 ~arm64"
fi

DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"
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

src_install() {
	distutils-r1_src_install

	if use zsh-completion; then
		insinto /usr/share/zsh/site-functions
		doins misc/zsh/_khard
	fi
}
