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
	)
"

distutils_enable_tests unittest

pkg_postinst() {
	optfeature "isa-l backend" dev-libs/isa-l
	optfeature "jerasure backend" dev-libs/jerasure
}
