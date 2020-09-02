# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6,7,8,9} )

inherit distutils-r1

DESCRIPTION="Python client for Sentry"
HOMEPAGE="https://getsentry.com https://pypi.org/project/sentry-sdk/"
SRC_URI="https://github.com/getsentry/sentry-python/archive/${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/sentry-python-${PV}"

LICENSE="PSF-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc ~ppc64 ~x86"

RDEPEND="
	dev-python/urllib3[${PYTHON_USEDEP}]
	dev-python/certifi[${PYTHON_USEDEP}]
"

# No tests for now
# Need unpackaged: executing, fakeredis
