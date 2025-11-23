# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_EXT=1
DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{11..14} )

inherit distutils-r1 optfeature pypi

DESCRIPTION="Messaging API for RPC and notifications over different messaging transports"
HOMEPAGE="
	https://opendev.org/openstack/pyeclib/
	https://pypi.org/project/pyeclib/
"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ~arm64 x86"

DEPEND="
	dev-libs/liberasurecode
"
RDEPEND="
	${DEPEND}
"
BDEPEND="
	test? (
		dev-libs/isa-l
		dev-libs/jerasure
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
	optfeature "isa-l backend" dev-libs/isa-l
	optfeature "jerasure backend" dev-libs/jerasure
}
