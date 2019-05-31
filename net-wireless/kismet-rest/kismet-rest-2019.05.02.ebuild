# Copyright 2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python2_7 python3_6 )
inherit distutils-r1

DESCRIPTION="Kismet REST Python API"
HOMEPAGE="https://kismetwireless.net/docs/devel/webui_rest/endpoints/"
if [ "${PV}" = "9999" ]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/kismetwireless/python-kismet-rest.git"
else
	KEYWORDS="~amd64 ~x86"
	SRC_URI="https://github.com/kismetwireless/python-kismet-rest/archive/${PV}.tar.gz -> ${P}.tar.gz"
	S="${WORKDIR}/python-${P}"
fi

LICENSE="GPL-2+"
SLOT="0"
IUSE=""

DEPEND="dev-python/requests
		!<net-wireless/kismet-2019.05.1"
RDEPEND="${DEPEND}"
BDEPEND=""
