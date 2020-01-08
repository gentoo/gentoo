# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 python3_6 )

inherit distutils-r1

DESCRIPTION="Python language binding for Selenium Remote Control"
HOMEPAGE="http://www.seleniumhq.org"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

KEYWORDS="amd64 arm ~ia64 ~ppc ppc64 ~sparc x86"
LICENSE="Apache-2.0"
SLOT="0"

DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"

DOCS=( py/CHANGES py/README.rst )

QA_PREBUILT="/usr/lib*/python*/site-packages/${PN}/webdriver/firefox/*/x_ignore_nofocus.so"
