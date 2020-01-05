# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 python3_{6,7} )
inherit distutils-r1

DESCRIPTION="A modern/fast Python SOAP client based on lxml / requests"
HOMEPAGE="http://docs.python-zeep.org/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="async -tornado"

DEPEND="dev-python/setuptools"
RDEPEND="${DEPEND}
	>=dev-python/appdirs-1.4.0
	>=dev-python/attrs-17.2.0
	>=dev-python/cached-property-1.3.0
	>=dev-python/defusedxml-0.4.1
	>=dev-python/isodate-0.5.4
	>=dev-python/lxml-3.1.0
	>=dev-python/requests-2.7.0
	>=dev-python/requests-toolbelt-0.7.1
	>=dev-python/six-1.9.0
	dev-python/pytz
	async? ( >=dev-python/aiohttp-1.0 )
	tornado? (
		>=www-servers/tornado-4.0.2
		<www-servers/tornado-5
		)"

DOCS=( README.rst CHANGES )
