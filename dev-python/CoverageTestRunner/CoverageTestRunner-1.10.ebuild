# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/CoverageTestRunner/CoverageTestRunner-1.10.ebuild,v 1.9 2015/04/08 08:04:59 mgorny Exp $

EAPI=5

PYTHON_COMPAT=( python2_7 )

inherit distutils-r1 python-r1

MY_PN="python-coverage-test-runner"
DESCRIPTION="fail Python program unit tests unless they test everything"
HOMEPAGE="http://liw.fi/coverage-test-runner/"
SRC_URI="http://code.liw.fi/debian/pool/main/p/${MY_PN}/${MY_PN}_${PV}.orig.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86"
IUSE=""

DEPEND="${PYTHON_DEPS}
	dev-python/coverage"
RDEPEND="${DEPEND}"
