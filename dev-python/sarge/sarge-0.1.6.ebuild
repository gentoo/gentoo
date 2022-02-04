# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..10} )
DISTUTILS_USE_SETUPTOOLS=no
inherit distutils-r1

COMMIT="81dc3347651b"

DESCRIPTION="wrapper for subprocess which provides command pipeline functionality"
HOMEPAGE="https://sarge.readthedocs.org/"
SRC_URI="
	https://bitbucket.org/vinay.sajip/sarge/get/${PV}.tar.gz
		-> ${P}.bb.tar.gz
"
S="${WORKDIR}/vinay.sajip-${PN}-${COMMIT}"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~x86"

python_test() {
	"${EPYTHON}" test_sarge.py -v || die "Tests failed with ${EPYTHON}"
}
