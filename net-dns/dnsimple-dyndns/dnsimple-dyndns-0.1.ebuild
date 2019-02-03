# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

PYTHON_COMPAT=( python2_7 )

GIT_ECLASS=
if [[ ${PV} = *9999* ]]; then
	GIT_ECLASS="git-r3"
	EGIT_REPO_URI="https://github.com/rafaelmartins/${PN}.git"
fi

inherit distutils-r1 ${GIT_ECLASS}

DESCRIPTION="Dynamic DNS implementation, that relies on DNSimple.com"
HOMEPAGE="https://pypi.org/project/dnsimple-dyndns/
	https://github.com/rafaelmartins/dnsimple-dyndns"

SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"
KEYWORDS="~amd64 ~x86"
if [[ ${PV} = *9999* ]]; then
	SRC_URI=""
	KEYWORDS=""
fi

LICENSE="BSD"
SLOT="0"
IUSE=""

DEPEND=">=dev-python/requests-2.0.0"
RDEPEND="${DEPEND}"
