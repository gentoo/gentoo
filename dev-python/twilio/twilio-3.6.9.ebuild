# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/twilio/twilio-3.6.9.ebuild,v 1.2 2015/04/08 08:05:28 mgorny Exp $

EAPI=5

PYTHON_COMPAT=( python{2_7,3_3,3_4} )

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
		dev-python/socksipy[${PYTHON_USEDEP}]"

RDEPEND="${CDEPEND}"
DEPEND="test? (
			${CDEPEND}
			dev-python/nose[${PYTHON_USEDEP}]
		)"

python_test() {
	nosetests tests || die "Tests fail with ${EPYTHON}"
}
