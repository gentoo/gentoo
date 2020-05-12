# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6,7} )
inherit distutils-r1

DESCRIPTION="Command shell for managing Linux LIO kernel target"
HOMEPAGE="https://github.com/open-iscsi/targetcli-fb"
SRC_URI="https://github.com/open-iscsi/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 ~x86"

RDEPEND="dev-python/configshell-fb[${PYTHON_USEDEP}]
	dev-python/pygobject:3[${PYTHON_USEDEP}]
	dev-python/rtslib-fb[${PYTHON_USEDEP}]
	dev-python/six[${PYTHON_USEDEP}]
	sys-apps/dbus"

src_install() {
	distutils-r1_src_install

	keepdir /etc/target /etc/target/backup
	doman targetcli.8
}
