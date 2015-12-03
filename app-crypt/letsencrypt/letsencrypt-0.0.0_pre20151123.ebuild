# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

if [[ ${PV} == "9999" ]] ; then
	EGIT_REPO_URI="https://github.com/letsencrypt/letsencrypt.git"
	inherit git-r3
else
	MY_PV="${PV/_pre/.dev}"
	MY_P="${PN}-${MY_PV}"
	SRC_URI="https://github.com/letsencrypt/letsencrypt/archive/v${MY_PV}.tar.gz -> ${MY_P}.tar.gz"
	KEYWORDS="~amd64 ~arm ~x86"
	S="${WORKDIR}/${MY_P}"
fi

DESCRIPTION="Let's Encrypt client to automate deployment of X.509 certificates"
HOMEPAGE="https://github.com/letsencrypt/letsencrypt https://letsencrypt.org/"

LICENSE="Apache-2.0"
SLOT="0"
IUSE="test"

RDEPEND=">=app-crypt/acme-${PV}[${PYTHON_USEDEP}]
	dev-python/configargparse[${PYTHON_USEDEP}]
	dev-python/configobj[${PYTHON_USEDEP}]
	>=dev-python/cryptography-0.7[${PYTHON_USEDEP}]
	dev-python/mock[${PYTHON_USEDEP}]
	dev-python/parsedatetime[${PYTHON_USEDEP}]
	>=dev-python/psutil-2.1.0[${PYTHON_USEDEP}]
	>=dev-python/pyopenssl-0.15[${PYTHON_USEDEP}]
	dev-python/pyrfc3339[${PYTHON_USEDEP}]
	>=dev-python/pythondialog-3.2.2:python-2[${PYTHON_USEDEP}]
	dev-python/pytz[${PYTHON_USEDEP}]
	dev-python/requests[${PYTHON_USEDEP}]
	dev-python/zope-component[${PYTHON_USEDEP}]
	dev-python/zope-interface[${PYTHON_USEDEP}]"
DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]
	test? (
		${RDEPEND}
		dev-python/nose[${PYTHON_USEDEP}]
	)"

python_test() {
	nosetests -w ${PN}/tests || die
}
