# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/south/south-0.8.4.ebuild,v 1.4 2014/10/10 10:59:18 ago Exp $

EAPI=5

PYTHON_COMPAT=( python{2_7,3_3,3_4} pypy )

inherit vcs-snapshot distutils-r1

DESCRIPTION="Intelligent schema migrations for Django apps"
HOMEPAGE="http://south.aeracode.org/"
SRC_URI="https://bitbucket.org/andrewgodwin/south/get/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="doc test"

RDEPEND="dev-python/django[${PYTHON_USEDEP}]"
DEPEND="${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]
	doc? (
		dev-python/jinja[${PYTHON_USEDEP}]
		dev-python/sphinx[${PYTHON_USEDEP}] )
	test? ( dev-python/django[sqlite] )"

python_compile_all() {
	use doc && emake -C docs html
}

python_install_all() {
	use doc && local HTML_DOCS=( docs/_build/html/. )
	distutils-r1_python_install_all
}

python_test() {
	# http://south.aeracode.org/ticket/1439
	cd "${BUILD_DIR}" || die
	django-admin.py startproject southtest || die "setting up test env failed"

	pushd southtest > /dev/null
	sed -e "/^INSTALLED_APPS/a\    'south'," \
		-e '$a\SKIP_SOUTH_TESTS=False' \
		-i southtest/settings.py || die "test sed failed"
	"${EPYTHON}" manage.py test south || die "tests failed for ${EPYTHON}"
	popd > /dev/null
}

pkg_postinst() {
	elog "In order to use the south schema migrations for your Django project,"
	elog "just add 'south' to your INSTALLED_APPS in the settings.py file."
	elog "manage.py will now automagically offer the new functions."
}
