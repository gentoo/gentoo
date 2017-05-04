# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 python3_4 python3_5 python3_6 )
PYTHON_REQ_USE="threads(+)"

inherit python-any-r1 waf-utils

DESCRIPTION="tiny C++ library which wraps std::stringstream in a mutex"
HOMEPAGE="http://carlh.net/locked_sstream"
SRC_URI="http://carlh.net/downloads/${PN}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

RDEPEND=""
DEPEND="dev-util/waf
	${PYTHON_DEPS}"

src_prepare() {
	rm -vf ./waf || die
	WAF_BINARY=${EROOT}usr/bin/waf

	default
}
