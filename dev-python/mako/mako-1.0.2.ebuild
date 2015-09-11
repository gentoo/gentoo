# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python{2_7,3_3,3_4} )

inherit distutils-r1 eutils versionator

MY_PN="Mako"
MY_P=${MY_PN}-${PV}

DESCRIPTION="A Python templating language"
HOMEPAGE="http://www.makotemplates.org/ https://pypi.python.org/pypi/Mako"
SRC_URI="mirror://pypi/${MY_PN:0:1}/${MY_PN}/${MY_P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~amd64-linux ~x86-linux ~x64-macos ~x86-macos"
IUSE="doc test"

RDEPEND="
	>=dev-python/markupsafe-0.9.2[${PYTHON_USEDEP}]"
DEPEND="${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]
	test? (
		dev-python/nose[${PYTHON_USEDEP}]
		$(python_gen_cond_dep 'dev-python/mock[${PYTHON_USEDEP}]' python2_7)
	)"

S="${WORKDIR}/${MY_P}"

python_test() {
	nosetests "${S}"/test || die "Tests fail with ${EPYTHON}"
}

python_install_all() {
	rm -rf doc/build || die

	use doc && local HTML_DOCS=( doc/. )
	distutils-r1_python_install_all
}

pkg_postinst() {
	optfeature dev-python/beaker "Caching support"
	for v in ${REPLACING_VERSIONS}; do
		if ! version_is_at_least 0.7.3-r2 $v; then
			ewarn "dev-python/beaker is no longer hard dependency of ${P}"
			ewarn "If you rely on it, you should add beaker to your world"
			ewarn "file:"
			ewarn "# emerge --noreplace beaker"
			break
		fi
	done
}
