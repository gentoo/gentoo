# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=flit
PYTHON_COMPAT=( python3_{10..13} pypy3 )

inherit distutils-r1 git-r3

DESCRIPTION="Check live packages for updates and emerge them as necessary"
HOMEPAGE="https://github.com/projg2/smart-live-rebuild/"
EGIT_REPO_URI="https://github.com/projg2/${PN}.git"

LICENSE="BSD-2"
SLOT="0"

RDEPEND=">=app-portage/gentoopm-0.2.1[${PYTHON_USEDEP}]"

distutils_enable_tests pytest

python_install_all() {
	distutils-r1_python_install_all

	insinto /etc/portage
	newins smart-live-rebuild.conf{.example,}
	insinto /usr/share/portage/config/sets
	newins sets.conf.example smart-live-rebuild.conf
}
