# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{8..10} )

inherit distutils-r1 virtualx

DESCRIPTION="Command line interface for controlling Razer devices on Linux"
HOMEPAGE="https://github.com/LoLei/razer-cli/"

if [[ ${PV} == *9999* ]] ; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/LoLei/${PN}.git"
else
	SRC_URI="https://github.com/LoLei/${PN}/archive/v${PV}.tar.gz -> ${P}.gh.tar.gz"
	KEYWORDS="~amd64 ~x86"
fi

LICENSE="GPL-3+"
SLOT="0"

RDEPEND="
	sys-apps/openrazer[client,daemon,${PYTHON_USEDEP}]
	x11-apps/xrdb
"
BDEPEND="${RDEPEND}"

PATCHES=( "${FILESDIR}"/${PN}-setup.patch )

distutils_enable_tests unittest

src_test() {
	virtx distutils-r1_src_test
}
