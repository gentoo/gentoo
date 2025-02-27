# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..13} pypy3 pypy3_11 )

inherit distutils-r1 pypi

DESCRIPTION="Parse and generate Authentication-Results headers"
HOMEPAGE="
	https://launchpad.net/authentication-results-python/
	https://pypi.org/project/authres/
"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 arm64 x86"

python_test() {
	"${EPYTHON}" -m doctest -v authres/tests ||
		die "Tests fail with ${EPYTHON}"
}
