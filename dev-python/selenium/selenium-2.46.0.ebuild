# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/selenium/selenium-2.46.0.ebuild,v 1.1 2015/06/19 09:38:38 jlec Exp $

EAPI=5

PYTHON_COMPAT=( python2_7 python3_{3,4} )

inherit distutils-r1

DESCRIPTION="Python language binding for Selenium Remote Control (version 1.0 and 2.0)"
HOMEPAGE="http://pypi.python.org/pypi/selenium/ https://github.com/SeleniumHQ/selenium http://www.seleniumhq.org"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

KEYWORDS="~amd64 ~arm ~ppc64 ~x86"
IUSE="doc"
LICENSE="Apache-2.0"
SLOT="0"

DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"

DOCS=( py/CHANGES py/README )
DISTUTILS_IN_SOURCE_BUILD=1
QA_PREBUILT="/usr/lib*/python*/site-packages/${PN}/webdriver/firefox/*/x_ignore_nofocus.so"
