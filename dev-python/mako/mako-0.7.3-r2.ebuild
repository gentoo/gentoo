# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/mako/mako-0.7.3-r2.ebuild,v 1.14 2014/12/12 05:43:54 idella4 Exp $

EAPI=5

PYTHON_COMPAT=( python{2_7,3_3,3_4} )

inherit readme.gentoo versionator distutils-r1

MY_P="Mako-${PV}"

DESCRIPTION="A Python templating language"
HOMEPAGE="http://www.makotemplates.org/ http://pypi.python.org/pypi/Mako"
SRC_URI="http://www.makotemplates.org/downloads/${MY_P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm ~hppa ia64 ppc ~ppc64 ~s390 ~sh sparc x86 ~amd64-linux ~x86-linux ~x64-macos ~x86-macos"
IUSE="doc test"

RDEPEND="
	>=dev-python/markupsafe-0.9.2[${PYTHON_USEDEP}]"
DEPEND="${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]
	test? ( dev-python/nose[${PYTHON_USEDEP}]
		$(python_gen_cond_dep 'dev-python/mock[${PYTHON_USEDEP}]' python2_7) )"

S="${WORKDIR}/${MY_P}"

PATCHES=(
	"${FILESDIR}/test-fix.patch"
)

DOC_CONTENTS="
${PN} can be enchanced with caching by dev-python/beaker"

python_test() {
	cp -r -l test "${BUILD_DIR}"/ || die

	if [[ ${EPYTHON} == python3.* ]]; then
		# Notes:
		#   -W is not supported by python3.1
		#   -n causes Python to write into hardlinked files
		2to3 --no-diffs -w "${BUILD_DIR}"/test || die
	fi

	cd "${BUILD_DIR}"/test || die
	nosetests || die "Tests fail with ${EPYTHON}"
}

python_install_all() {
	rm -rf doc/build

	use doc && local HTML_DOCS=( doc/. )
	distutils-r1_python_install_all
	readme.gentoo_create_doc
}

pkg_postinst() {
	readme.gentoo_print_elog

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
