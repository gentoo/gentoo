# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

PYTHON_COMPAT=( python2_7 python3_{4,5,6,7} pypy{,3} )

inherit distutils-r1

DESCRIPTION="httpstat visualizes cURL statistics in a way of beauty and clarity"
HOMEPAGE="https://github.com/reorx/httpstat"
SRC_URI="https://github.com/reorx/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"
RDEPEND="net-misc/curl:*"

# Requires access to google.com and http2.akamai.com
RESTRICT="test"

PATCHES=( "${FILESDIR}"/${PN}-1.2.1-gentoo-tests.patch )

python_test() {
	./httpstat_test.sh || die
}
