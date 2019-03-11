# Copyright 2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python2_7 python3_{6,7} )
inherit git-r3 distutils-r1

DESCRIPTION="Kismetdb database log helper library"
HOMEPAGE="https://kismetwireless.net/"
SRC_URI=""
EGIT_REPO_URI="https://www.kismetwireless.net/git/python-kismet-db.git"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE=""

DEPEND="dev-python/python-dateutil[${PYTHON_USEDEP}]
	dev-python/simplekml[${PYTHON_USEDEP}]"
RDEPEND="${DEPEND}"
BDEPEND=""
