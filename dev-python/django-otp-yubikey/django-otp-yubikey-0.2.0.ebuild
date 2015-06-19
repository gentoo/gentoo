# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/django-otp-yubikey/django-otp-yubikey-0.2.0.ebuild,v 1.3 2015/04/14 07:19:03 jlec Exp $

EAPI=5

PYTHON_COMPAT=( python2_7 python3_{3,4} )

inherit distutils-r1

DESCRIPTION="django-otp plugin that verifies YubiKey OTP tokens"
HOMEPAGE="https://bitbucket.org/psagers/django-otp"
SRC_URI="mirror://pypi/d/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

RDEPEND="
	dev-python/django-otp[${PYTHON_USEDEP}]
	dev-python/yubiotp[${PYTHON_USEDEP}]"
DEPEND="${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]
"
