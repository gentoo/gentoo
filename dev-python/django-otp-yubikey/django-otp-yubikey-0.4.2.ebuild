# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python2_7 python3_{5,6} )

inherit distutils-r1

DESCRIPTION="django-otp plugin that verifies YubiKey OTP tokens"
HOMEPAGE="https://bitbucket.org/psagers/django-otp"
SRC_URI="mirror://pypi/d/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

RDEPEND="
	>=dev-python/django-otp-0.4.0[${PYTHON_USEDEP}]
	>=dev-python/yubiotp-0.2.1[${PYTHON_USEDEP}]"
DEPEND="${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]
"
