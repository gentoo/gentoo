# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( pypy3 python3_{8..10} )

inherit distutils-r1

DESCRIPTION="Parse human-readable date/time strings"
HOMEPAGE="https://github.com/bear/parsedatetime"
# Tests aren't detected in PyPI tarballs
# https://github.com/bear/parsedatetime/pull/252
SRC_URI="https://github.com/bear/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 ~arm ~arm64 ~ppc64 x86"

distutils_enable_tests pytest
