# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/recaptcha-client/recaptcha-client-1.0.6-r1.ebuild,v 1.6 2015/04/08 08:05:25 mgorny Exp $

EAPI=5
PYTHON_COMPAT=( python{2_7,3_3,3_4} )

inherit distutils-r1

DESCRIPTION="A plugin for reCAPTCHA and reCAPTCHA Mailhide"
HOMEPAGE="http://pypi.python.org/pypi/recaptcha-client/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"
KEYWORDS="amd64 x86"
IUSE=""

LICENSE="MIT"
SLOT="0"

RDEPEND="dev-python/pycrypto[${PYTHON_USEDEP}]"
DEPEND="${RDEPEND} dev-python/setuptools[${PYTHON_USEDEP}]"
