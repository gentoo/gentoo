# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/yubiotp/yubiotp-0.2.1.ebuild,v 1.3 2015/04/08 08:05:24 mgorny Exp $

EAPI=5

PYTHON_COMPAT=( python{2_7,3_3,3_4} )

inherit eutils distutils-r1

MY_PN="YubiOTP"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="Python library for verifying YubiKey OTP tokens, both locally and through a Yubico web service"
HOMEPAGE="https://bitbucket.org/psagers/yubiotp"
SRC_URI="mirror://pypi/Y/${MY_PN}/${MY_P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"

IUSE="test"

S="${WORKDIR}/${MY_P}"

CDEPEND="dev-python/six[${PYTHON_USEDEP}]
		dev-python/pycrypto[${PYTHON_USEDEP}]"

RDEPEND="${CDEPEND}"
DEPEND="test? ( ${CDEPEND} )"

python_test() {
	esetup.py test
}
