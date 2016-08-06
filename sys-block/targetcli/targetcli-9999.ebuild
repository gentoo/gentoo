# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

PYTHON_COMPAT=( python2_7 )

inherit distutils-r1 linux-info

if [[ ${PV} == 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="git://github.com/Datera/${PN}.git
		https://github.com/Datera/${PN}.git"
	KEYWORDS=""
else
	MY_PV=${PV/_/-}
	SRC_URI="https://github.com/Datera/${PN}/archive/${PV/_/-}.tar.gz -> ${P}.tar.gz"
	S="${WORKDIR}/${PN}-${MY_PV}"
	KEYWORDS="~amd64"
fi

DESCRIPTION="CLI and shell for the Linux SCSI target"
HOMEPAGE="http://linux-iscsi.org/wiki/targetcli"

LICENSE="Apache-2.0"
SLOT="0"
IUSE=""

DEPEND="dev-python/configshell[${PYTHON_USEDEP}]
	dev-python/prettytable[${PYTHON_USEDEP}]
	dev-python/rtslib[${PYTHON_USEDEP}]"
RDEPEND="${DEPEND}
	dev-python/urwid[${PYTHON_USEDEP}]"

pkg_pretend() {
	if use kernel_linux; then
		linux-info_get_any_version
		if ! linux_config_exists; then
			eerror "Unable to check your kernel for SCSI target support"
		else
			CONFIG_CHECK="~TARGET_CORE"
			check_extra_config
		fi
	fi
}
