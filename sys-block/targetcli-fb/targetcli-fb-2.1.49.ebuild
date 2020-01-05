# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python2_7 python3_6 )
inherit distutils-r1

MY_PV=$(ver_rs 2 .fb)

DESCRIPTION="Command shell for managing Linux LIO kernel target"
HOMEPAGE="https://github.com/open-iscsi/targetcli-fb"
SRC_URI="https://github.com/open-iscsi/${PN}/archive/v${MY_PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"

BDEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"
RDEPEND="dev-python/configshell-fb[${PYTHON_USEDEP}]
	dev-python/pygobject:3[${PYTHON_USEDEP}]
	dev-python/rtslib-fb[${PYTHON_USEDEP}]
	dev-python/six[${PYTHON_USEDEP}]
	sys-apps/dbus"

S="${WORKDIR}/${PN}-${MY_PV}"

src_install() {
	distutils-r1_src_install

	keepdir /etc/target /etc/target/backup
	doman targetcli.8
}
