# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
PYTHON_COMPAT=(python2_7)

if [[ ${PV} == 9999* ]]; then
	EGIT_REPO_URI="https://github.com/certbot/certbot.git"
	inherit git-r3
	S=${WORKDIR}/${P}/${PN}
else
	SRC_URI="https://github.com/${PN%-apache}/${PN%-apache}/archive/v${PV}.tar.gz -> ${PN%-apache}-${PV}.tar.gz"
	KEYWORDS="~amd64"
	S=${WORKDIR}/${PN%-apache}-${PV}/${PN}
fi

inherit distutils-r1

DESCRIPTION="Apache plugin for certbot (Let's Encrypt Client)"
HOMEPAGE="https://github.com/certbot/certbot https://letsencrypt.org/"

LICENSE="Apache-2.0"
SLOT="0"
IUSE="test"

RDEPEND="~app-crypt/certbot-${PV}[${PYTHON_USEDEP}]
	~app-crypt/acme-${PV}[${PYTHON_USEDEP}]
	dev-python/mock[${PYTHON_USEDEP}]
	dev-python/python-augeas[${PYTHON_USEDEP}]
	dev-python/zope-component[${PYTHON_USEDEP}]
	dev-python/zope-interface[${PYTHON_USEDEP}]"
DEPEND="test? ( ${RDEPEND}
	dev-python/nose[${PYTHON_USEDEP}] )
	dev-python/setuptools[${PYTHON_USEDEP}]"

python_test() {
	nosetests || die
}
