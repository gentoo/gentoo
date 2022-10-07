# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..10} )
inherit distutils-r1 systemd

DESCRIPTION="Command shell for managing Linux LIO kernel target"
HOMEPAGE="https://github.com/open-iscsi/targetcli-fb"
SRC_URI="https://github.com/open-iscsi/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm ~arm64 ~ia64 ~mips ~ppc ~ppc64 ~riscv ~sparc x86"

RDEPEND="dev-python/configshell-fb[${PYTHON_USEDEP}]
	dev-python/pygobject:3[${PYTHON_USEDEP}]
	>=dev-python/rtslib-fb-2.1.73[${PYTHON_USEDEP}]
	dev-python/six[${PYTHON_USEDEP}]
	sys-apps/dbus"

src_install() {
	distutils-r1_src_install

	keepdir /etc/target /etc/target/backup
	doman targetcli.8
	systemd_dounit systemd/targetclid.{service,socket}
}
