# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/envisage/envisage-4.3.0-r1.ebuild,v 1.1 2013/04/14 06:35:17 idella4 Exp $

EAPI=5

# py2.6 fails testsuite horribly
PYTHON_COMPAT=python2_7

inherit distutils-r1 virtualx

DESCRIPTION="Enthought Tool Suite: Extensible application framework"
HOMEPAGE="http://code.enthought.com/projects/envisage/ http://pypi.python.org/pypi/envisage"
SRC_URI="http://www.enthought.com/repo/ets/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="doc examples test"

RDEPEND=">=dev-python/traits-4[${PYTHON_USEDEP}]"
DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]
	doc? ( dev-python/sphinx[${PYTHON_USEDEP}] )
	test? (
		>=dev-python/traits-4[${PYTHON_USEDEP}]
		dev-python/apptools
		media-fonts/font-cursor-misc
		media-fonts/font-misc-misc
	)"

python_compile_all() {
	use doc && emake -C docs html
}

python_test() {
	# Delete these on action from https://github.com/enthought/envisage/issues/21
	VIRTUALX_COMMAND="nosetests -e test_dynamically_added_category* \
		-e test_dynamically_added_class_load_hooks* \
		-e test_only_find_plugins_matching_a_wildcard_in_the_include_list* \
		-e test_only_find_plugins_whose_ids_are_in_the_include_list" virtualmake
}

python_install_all() {
	distutils-r1_python_install_all
	use doc && dohtml -r docs/build/html/

	if use examples; then
		insinto /usr/share/doc/${PF}
		doins -r examples
	fi
}
