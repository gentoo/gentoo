# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python{2_7,3_3,3_4} pypy )

inherit distutils-r1 eutils multilib-minimal

DESCRIPTION="A streaming protocol for test results"
HOMEPAGE="https://launchpad.net/subunit http://pypi.python.org/pypi/python-subunit"
SRC_URI="http://launchpad.net/${PN}/trunk/${PV}/+download/${P}.tar.gz"

LICENSE="Apache-2.0 BSD"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~x86 ~x86-fbsd"
#need to keyword the following in =dev-python/extras-0.0.3 then readd the keywords here
#ia64 s390 sh sparc amd64-fbsd
IUSE="static-libs"

RDEPEND=">=dev-python/testtools-0.9.34[${PYTHON_USEDEP}]
	dev-python/extras[${PYTHON_USEDEP}]"
#	test? ( dev-python/testscenarios[${PYTHON_USEDEP}] )
#requires keywording first; Bug #506510
DEPEND="${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]
	dev-lang/perl:=
	>=dev-libs/check-0.9.11[${MULTILIB_USEDEP}]
	>=dev-util/cppunit-1.13.2[${MULTILIB_USEDEP}]
	>=virtual/pkgconfig-0-r1[${MULTILIB_USEDEP}]"
#requires keywording first; Bug #506510
RESTRICT="test"

src_prepare() {
	sed -i -e 's/os.chdir(os.path.dirname(__file__))//' setup.py || die
	# needed for perl modules
	multilib_copy_sources
	distutils-r1_src_prepare
}

multilib_src_configure() {
	ECONF_SOURCE=${S} \
	econf \
		--enable-shared \
		$(use_enable static-libs static)
}

multilib_src_compile() {
	default
	multilib_is_native_abi && distutils-r1_src_compile
}

python_test() {
	local -x PATH="${PWD}/shell/share:${PATH}"
	local -x PYTHONPATH=python
	"${PYTHON}" -m testtools.run all_tests.test_suite || die "Testing failed with ${EPYTHON}"
}

multilib_src_test() {
	multilib_is_native_abi && distutils-r1_src_test
}

multilib_src_install() {
	local targets=(
		install-include_subunitHEADERS
		install-pcdataDATA
		install-exec-local
		install-libLTLIBRARIES
	)
	emake DESTDIR="${D}" "${targets[@]}"

	multilib_is_native_abi && distutils-r1_src_install
}

multilib_src_install_all() {
	einstalldocs
	prune_libtool_files
}
