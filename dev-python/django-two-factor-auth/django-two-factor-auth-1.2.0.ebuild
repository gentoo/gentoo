# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/django-two-factor-auth/django-two-factor-auth-1.2.0.ebuild,v 1.1 2015/05/09 07:04:51 ercpe Exp $

EAPI=5

PYTHON_COMPAT=( python{2_7,3_3,3_4} )

inherit eutils distutils-r1

DESCRIPTION="User-friendly Two-Factor Authentication for Django"
HOMEPAGE="https://github.com/Bouke/django-two-factor-auth"
SRC_URI="https://github.com/Bouke/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"

IUSE="test yubikey"

CDEPEND=">=dev-python/django-1.4.2[${PYTHON_USEDEP}]
		>=dev-python/django-otp-0.2.0[${PYTHON_USEDEP}]
		dev-python/qrcode[${PYTHON_USEDEP}]
		dev-python/twilio[${PYTHON_USEDEP}]
		yubikey? ( dev-python/django-otp-yubikey[${PYTHON_USEDEP}] )
		"

RDEPEND="${CDEPEND}"
DEPEND="test? (
			dev-python/flake8[${PYTHON_USEDEP}]
			dev-python/mock[${PYTHON_USEDEP}]
			${CDEPEND}
		)"

python_prepare_all() {
	distutils-r1_python_prepare_all
	sed -i "/'qrcode/s/^/#/" setup.py || die
}

python_test() {
	emake test
}
