# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..9} )

inherit distutils-r1 optfeature

DESCRIPTION="Messaging API for RPC and notifications over different messaging transports"
HOMEPAGE="https://pypi.org/project/PyECLib/"
SRC_URI="mirror://pypi/p/pyeclib/pyeclib-${PV}.tar.gz"
S="${WORKDIR}/pyeclib-${PV}"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ~arm64 x86"

DEPEND="dev-libs/liberasurecode"
RDEPEND="${DEPEND}"
BDEPEND="
	test? (
		dev-python/six[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests unittest

src_prepare() {
	# https://review.opendev.org/c/openstack/pyeclib/+/798010
	sed -e '/library_dirs/d' -i setup.py || die
	distutils-r1_src_prepare
}

pkg_postinst() {
	optfeature "jerasure backend" dev-libs/jerasure
}
