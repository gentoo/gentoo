# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{7..10} )
inherit distutils-r1 git-r3

DESCRIPTION="Build Bespoke OS Images"
HOMEPAGE="https://github.com/systemd/${PN}"
EGIT_REPO_URI="${HOMEPAGE}.git"
EGIT_COMMIT="v${PVR}"
EGIT_COMMIT="v${PVR}"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="amd64"
RDEPEND="sys-apps/portage dev-vcs/git"

python_install_all() {
	distutils-r1_python_install_all
}
