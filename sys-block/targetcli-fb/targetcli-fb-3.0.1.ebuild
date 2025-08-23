# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..13} )
DISTUTILS_USE_PEP517=hatchling
inherit distutils-r1 systemd

DESCRIPTION="Command shell for managing Linux LIO kernel target"
HOMEPAGE="https://github.com/open-iscsi/targetcli-fb"
SRC_URI="https://github.com/open-iscsi/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~loong ~mips ppc ppc64 ~riscv ~sparc x86"

RDEPEND="
	dev-python/configshell-fb[${PYTHON_USEDEP}]
	dev-python/pygobject:3[${PYTHON_USEDEP}]
	>=dev-python/rtslib-fb-2.2.3[${PYTHON_USEDEP}]
	sys-apps/dbus"
BDEPEND="dev-python/hatch-vcs[${PYTHON_USEDEP}]"

export SETUPTOOLS_SCM_PRETEND_VERSION=${PV}

src_install() {
	distutils-r1_src_install

	keepdir /etc/target /etc/target/backup
	doman targetcli.8
	systemd_dounit systemd/targetclid.{service,socket}
}
