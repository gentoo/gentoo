# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
PYTHON_COMPAT=(python{2_7,3_4,3_5,3_6})

if [[ ${PV} == 9999* ]]; then
	EGIT_REPO_URI="https://github.com/certbot/certbot.git"
	inherit git-r3
else
	SRC_URI="https://github.com/${PN}/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~arm ~ppc64 ~x86"
fi

inherit distutils-r1

DESCRIPTION="Let's encrypt client to automate deployment of X.509 certificates"
HOMEPAGE="https://github.com/certbot/certbot https://letsencrypt.org/"

LICENSE="Apache-2.0"
SLOT="0"
IUSE="test"

CDEPEND=">=dev-python/setuptools-1.0[${PYTHON_USEDEP}]"
RDEPEND="
	${CDEPEND}
	~app-crypt/acme-${PV}[${PYTHON_USEDEP}]
	>=dev-python/configargparse-0.9.3[${PYTHON_USEDEP}]
	dev-python/configobj[${PYTHON_USEDEP}]
	>=dev-python/cryptography-1.2[${PYTHON_USEDEP}]
	dev-python/mock[${PYTHON_USEDEP}]
	>=dev-python/parsedatetime-1.3[${PYTHON_USEDEP}]
	dev-python/pyrfc3339[${PYTHON_USEDEP}]
	dev-python/pytz[${PYTHON_USEDEP}]
	dev-python/zope-component[${PYTHON_USEDEP}]
	dev-python/zope-interface[${PYTHON_USEDEP}]"
DEPEND="
	${CDEPEND}
	test? (
		>=dev-python/astroid-1.3.5[${PYTHON_USEDEP}]
		dev-python/coverage[${PYTHON_USEDEP}]
		dev-python/ipdb[${PYTHON_USEDEP}]
		dev-python/pytest[${PYTHON_USEDEP}]
		dev-python/pytest-cov[${PYTHON_USEDEP}]
		dev-python/pytest-xdist[${PYTHON_USEDEP}]
		>=dev-python/pylint-1.4.2[${PYTHON_USEDEP}]
		dev-python/wheel[${PYTHON_USEDEP}]
	)"

python_test() {
	nosetests -v ${PN} || die
}
