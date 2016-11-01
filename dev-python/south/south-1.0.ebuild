# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python2_7 python3_4 pypy )

inherit distutils-r1

MY_PN="South"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="Intelligent schema migrations for Django apps"
HOMEPAGE="http://south.aeracode.org/"
SRC_URI="mirror://pypi/${MY_P:0:1}/${MY_PN}/${MY_P}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="test"

RDEPEND="<dev-python/django-1.7[${PYTHON_USEDEP}]"
DEPEND="${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]
	test? ( dev-python/django[sqlite] )"

PATCHES=( "${FILESDIR}"/${P}-3753b49c-Replace-dict.iteritems-with-six.patch )

S="${WORKDIR}/${MY_P}"

python_test() {
	cd "${BUILD_DIR}" || die
	django-admin.py startproject southtest || die "setting up test env failed"
	pushd southtest > /dev/null
	sed -i \
		-e "/^INSTALLED_APPS/a\    'south'," \
		southtest/settings.py || die "sed failed"
	echo "SKIP_SOUTH_TESTS=False" >> southtest/settings.py
	"${EPYTHON}" manage.py test south || die "tests failed for ${EPYTHON}"
	popd > /dev/null
}

pkg_postinst() {
	elog "In order to use the south schema migrations for your Django project,"
	elog "just add 'south' to your INSTALLED_APPS in the settings.py file."
	elog "manage.py will now automagically offer the new functions."
}
