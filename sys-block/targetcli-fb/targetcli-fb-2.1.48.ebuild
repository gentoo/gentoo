# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 python3_{4,5} )

inherit distutils-r1 versionator

MY_PV=$(replace_version_separator 2 '.fb' ${PV})

DESCRIPTION="Command shell for managing Linux LIO kernel target"
HOMEPAGE="https://github.com/open-iscsi/targetcli-fb"
SRC_URI="https://github.com/open-iscsi/${PN}/archive/v${MY_PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"
RDEPEND="dev-python/configshell-fb[${PYTHON_USEDEP}]
	dev-python/pygobject:3[${PYTHON_USEDEP}]
	>=dev-python/rtslib-fb-2.1.62[${PYTHON_USEDEP}]
	dev-python/six[${PYTHON_USEDEP}]
	!sys-block/targetcli"

S="${WORKDIR}/${PN}-${MY_PV}"

src_install() {
	distutils-r1_src_install

	keepdir /etc/target /etc/target/backup
	doman targetcli.8
}
