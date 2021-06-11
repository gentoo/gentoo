# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7..9} )
inherit distutils-r1

MY_P=PyKerberos-${PV}
DESCRIPTION="A high-level Python wrapper for Kerberos/GSSAPI operations"
HOMEPAGE="
	https://www.calendarserver.org/PyKerberos.html
	https://github.com/apple/ccs-pykerberos/
	https://pypi.org/project/kerberos/"
SRC_URI="
	https://github.com/apple/ccs-pykerberos/archive/${MY_P}.tar.gz"
S=${WORKDIR}/ccs-pykerberos-${MY_P}

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 ~arm arm64 ~hppa ~ppc64 x86"
# test environment is non-trivial to set up, so just use docker
# (see python_test below)
# also for alpha/beta Python releases support:
# https://github.com/apple/ccs-pykerberos/pull/83/commits/5f1130a1305b5f6e7d7d8b41067c4713f0c8950f
RESTRICT="test"

RDEPEND="app-crypt/mit-krb5"
DEPEND="${RDEPEND}"

python_test() {
	set -- docker run \
		-v "${PWD}:/app" \
		-w /app \
		-e PYENV=$("${EPYTHON}" -c 'import sys; print(sys.version.split()[0])') \
		-e KERBEROS_USERNAME=administrator \
		-e KERBEROS_PASSWORD=Password01 \
		-e KERBEROS_REALM=example.com \
		-e KERBEROS_PORT=80 \
		ubuntu:16.04 \
		/bin/bash .travis.sh
	echo "${@}" >&2
	"${@}" || die "Tests failed with ${EPYTHON}"
}
