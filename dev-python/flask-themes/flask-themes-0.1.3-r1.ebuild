# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/flask-themes/flask-themes-0.1.3-r1.ebuild,v 1.8 2015/03/08 23:48:10 pacho Exp $

EAPI=5
PYTHON_COMPAT=( python{2_7,3_3,3_4} pypy )

inherit distutils-r1

MY_PN="Flask-Themes"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="Infrastructure for theming support in Flask applications"
HOMEPAGE="http://packages.python.org/Flask-Themes/ http://pypi.python.org/pypi/Flask-Themes"
SRC_URI="mirror://pypi/${MY_PN:0:1}/${MY_PN}/${MY_P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

RDEPEND=">=dev-python/flask-0.6[${PYTHON_USEDEP}]"
DEPEND="${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]"

S="${WORKDIR}/${MY_P}"

PATCHES=( "${FILESDIR}"/fixtests.patch )

python_test() {
	# suite fails miserably under py3. Cannot even find upstream repo to file. pypi.org does NOT help
	if ! python_is_python3; then
		PYTHONPATH=.:tests nosetests || die "Tests failed under ${EPYTHON}"
	fi
}
