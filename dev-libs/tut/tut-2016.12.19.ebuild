# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 )
PYTHON_REQ_USE='threads(+)'
NO_WAF_LIBDIR=yes

inherit python-any-r1 waf-utils

DESCRIPTION="C++ Template Unit Test Framework"
HOMEPAGE="http://mrzechonek.github.io/tut-framework/"
SRC_URI="https://github.com/mrzechonek/tut-framework/archive/${PV//./-}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=${PYTHON_DEPS}
RDEPEND=""

S="${WORKDIR}/tut-framework-${PV//./-}"
