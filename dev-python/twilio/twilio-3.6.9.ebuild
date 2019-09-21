# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

PYTHON_COMPAT=( python{2_7,3_5,3_6} )

inherit distutils-r1 vcs-snapshot

DESCRIPTION="Helper library for the Twilio API"
HOMEPAGE="https://github.com/twilio/twilio-python http://www.twilio.com/docs/python/install"
SRC_URI="https://github.com/twilio/${PN}-python/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"

IUSE="test"

CDEPEND="dev-python/six[${PYTHON_USEDEP}]
		dev-python/httplib2[${PYTHON_USEDEP}]
		dev-python/PySocks[${PYTHON_USEDEP}]"

RDEPEND="${CDEPEND}"
DEPEND="test? (
			${CDEPEND}
			dev-python/nose[${PYTHON_USEDEP}]
		)"

python_test() {
	nosetests tests || die "Tests fail with ${EPYTHON}"
}
