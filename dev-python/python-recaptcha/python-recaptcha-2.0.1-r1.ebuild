# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

DESCRIPTION="A plugin for reCAPTCHA and reCAPTCHA Mailhide"
HOMEPAGE="https://github.com/redhat-infosec/python-recaptcha"
SRC_URI="https://github.com/redhat-infosec/python-recaptcha/releases/download/v${PV}/${P}.tar.gz"
KEYWORDS="~amd64"

LICENSE="MIT"
SLOT="0"

RDEPEND="|| ( dev-python/pycryptodome[${PYTHON_USEDEP}] dev-python/pycrypto[${PYTHON_USEDEP}] )
	dev-python/simplejson[${PYTHON_USEDEP}]
	!dev-python/recaptcha-client"
DEPEND="${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]"
