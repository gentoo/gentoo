# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{9..11} pypy3 )

inherit distutils-r1 pypi

DESCRIPTION="Parse and generate Authentication-Results headers"
HOMEPAGE="
	https://launchpad.net/authentication-results-python/
	https://pypi.org/project/authres/
"

LICENSE="Apache-2.0"
KEYWORDS="amd64 arm64 x86"
SLOT="0"

python_test() {
	"${EPYTHON}" -m doctest -v authres/tests ||
		die "Tests fail with ${EPYTHON}"
}
