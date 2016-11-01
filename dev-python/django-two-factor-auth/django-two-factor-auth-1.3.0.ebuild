# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

# would support 3_5
PYTHON_COMPAT=( python{2_7,3_4} )

inherit eutils distutils-r1

DESCRIPTION="User-friendly Two-Factor Authentication for Django"
HOMEPAGE="https://github.com/Bouke/django-two-factor-auth"
SRC_URI="https://github.com/Bouke/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"

IUSE="test yubikey"

CDEPEND=">=dev-python/django-1.8[${PYTHON_USEDEP}]
		>=dev-python/django-otp-0.3.3[${PYTHON_USEDEP}]
		dev-python/qrcode[${PYTHON_USEDEP}]
		dev-python/twilio[${PYTHON_USEDEP}]
		>=dev-python/phonenumbers-7.0.9[${PYTHON_USEDEP}]
		=dev-python/django-phonenumber-field-0.7.2[${PYTHON_USEDEP}]
		dev-python/django-formtools[${PYTHON_USEDEP}]
		yubikey? ( dev-python/django-otp-yubikey[${PYTHON_USEDEP}] )
		"

RDEPEND="${CDEPEND}"
DEPEND="test? (
			dev-python/flake8[${PYTHON_USEDEP}]
			dev-python/mock[${PYTHON_USEDEP}]
			${CDEPEND}
		)"

python_test() {
	emake test
}
