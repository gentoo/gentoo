# Copyright 2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python2_7 python3_6 )
inherit distutils-r1 git-r3

DESCRIPTION="Kismet REST Python API"
HOMEPAGE="https://kismetwireless.net/docs/devel/webui_rest/endpoints/"
EGIT_REPO_URI="https://github.com/kismetwireless/python-kismet-rest.git"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS=""
IUSE=""

DEPEND="dev-python/requests
		!<net-wireless/kismet-2019.05.1"
RDEPEND="${DEPEND}"
BDEPEND=""
