# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/jdcal/jdcal-1.0.ebuild,v 1.5 2015/02/16 15:48:17 pacho Exp $

EAPI="5"

PYTHON_COMPAT=( python2_7 python3_{3,4} pypy pypy3 )

inherit distutils-r1

DESCRIPTION="Julian dates from proleptic Gregorian and Julian calendars"
HOMEPAGE="http://github.com/phn/jdcal"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD"
KEYWORDS="amd64 ~arm x86 ~amd64-linux ~x86-linux"
SLOT="0"
