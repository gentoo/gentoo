# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/PyGithub/PyGithub-1.25.0.ebuild,v 1.2 2015/04/08 08:05:27 mgorny Exp $

EAPI=5
PYTHON_COMPAT=( python{2_7,3_3,3_4} )

inherit distutils-r1

DESCRIPTION="Python library to access the Github API v3"
HOMEPAGE="https://github.com/jacquev6/PyGithub/"
# Use github since pypi is missing test data
SRC_URI="https://github.com/jacquev6/PyGithub/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="LGPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"

python_test() {
	esetup.py test
}
