# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
PYTHON_COMPAT=(python{2_7,3_4,3_5})

if [[ ${PV} == 9999* ]]; then
	EGIT_REPO_URI="https://github.com/letsencrypt/letsencrypt.git"
	inherit git-r3
	KEYWORDS=""
	S=${WORKDIR}/${P}/${PN}
else
	SRC_URI="https://github.com/letsencrypt/letsencrypt/archive/v${PV}.tar.gz -> letsencrypt-${PV}.tar.gz"
	KEYWORDS="~amd64"
	S=${WORKDIR}/letsencrypt-${PV}/acme
fi

inherit distutils-r1

DESCRIPTION="An implementation of the ACME protocol"
HOMEPAGE="https://github.com/letsencrypt/letsencrypt https://letsencrypt.org/"

LICENSE="Apache-2.0"
SLOT="0"
IUSE="test"

RDEPEND=">=dev-python/cryptography-0.8[${PYTHON_USEDEP}]
	dev-python/mock[${PYTHON_USEDEP}]
	>=dev-python/ndg-httpsclient-0.4[${PYTHON_USEDEP}]
	dev-python/pyasn1[${PYTHON_USEDEP}]
	>=dev-python/pyopenssl-0.15[${PYTHON_USEDEP}]
	dev-python/pyrfc3339[${PYTHON_USEDEP}]
	dev-python/pytz[${PYTHON_USEDEP}]
	dev-python/requests[${PYTHON_USEDEP}]
	dev-python/six[${PYTHON_USEDEP}]"
DEPEND="test? ( ${RDEPEND} dev-python/nose[${PYTHON_USEDEP}] )
	dev-python/setuptools[${PYTHON_USEDEP}]"

python_test() {
	nosetests -w ${PN} || die
}
