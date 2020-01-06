# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5
PYTHON_COMPAT=( python2_7 python3_6)
PYTHON_REQ_USE="threads(+)"

inherit eutils flag-o-matic distutils-r1 versionator

TWISTED_PN="Twisted"
TWISTED_P="${TWISTED_PN}-${PV}"
TWISTED_RELEASE=$(get_version_component_range 1-2 "${PV}")

DESCRIPTION="An asynchronous networking framework written in Python"
HOMEPAGE="https://www.twistedmatrix.com/trac/"
SRC_URI="https://twistedmatrix.com/Releases/${TWISTED_PN}"
SRC_URI="${SRC_URI}/${TWISTED_RELEASE}/${TWISTED_P}.tar.bz2
	https://dev.gentoo.org/~mgorny/dist/twisted-regen-cache.gz"

# Dropped keywords due to new deps not keyworded
#KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~ppc ~ppc64 ~s390 ~sh ~x86 ~ia64-hpux ~x86-interix ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
KEYWORDS="alpha amd64 arm arm64 hppa ia64 ~mips ppc ppc64 s390 sparc x86"

LICENSE="MIT"
SLOT="0"
IUSE="conch crypt http2 serial +soap test"
RESTRICT="!test? ( test )"

RDEPEND="
	>=dev-python/incremental-16.10.1[${PYTHON_USEDEP}]
	>=dev-python/zope-interface-4.0.2[${PYTHON_USEDEP}]
	conch? (
		dev-python/pyasn1[${PYTHON_USEDEP}]
		>=dev-python/cryptography-0.9.1[${PYTHON_USEDEP}]
		>=dev-python/appdirs-1.4.0[${PYTHON_USEDEP}]
	)
	crypt? (
		>=dev-python/pyopenssl-16.0.0[${PYTHON_USEDEP}]
		dev-python/service_identity[${PYTHON_USEDEP}]
		>=dev-python/idna-0.6[${PYTHON_USEDEP}]
	)
	serial? ( dev-python/pyserial[${PYTHON_USEDEP}] )
	soap? ( $(python_gen_cond_dep 'dev-python/soappy[${PYTHON_USEDEP}]' python2_7) )
	http2? (
		>=dev-python/hyper-h2-2.5.0[${PYTHON_USEDEP}]
		<dev-python/hyper-h2-3.0.0[${PYTHON_USEDEP}]
		>=dev-python/priority-1.1.0[${PYTHON_USEDEP}]
		<dev-python/priority-2.0[${PYTHON_USEDEP}]
	)
	>=dev-python/constantly-15.1.0[${PYTHON_USEDEP}]
	!dev-python/twisted-core
	!dev-python/twisted-conch
	!dev-python/twisted-lore
	!dev-python/twisted-mail
	!dev-python/twisted-names
	!dev-python/twisted-news
	!dev-python/twisted-pair
	!dev-python/twisted-runner
	!dev-python/twisted-words
	!dev-python/twisted-web
"
DEPEND="
	>=dev-python/incremental-16.10.1[${PYTHON_USEDEP}]
	test? (
		dev-python/gmpy[${PYTHON_USEDEP}]
		dev-python/pyasn1[${PYTHON_USEDEP}]
		>=dev-python/cryptography-0.9.1[${PYTHON_USEDEP}]
		>=dev-python/appdirs-1.4.0[${PYTHON_USEDEP}]
		>=dev-python/pyopenssl-0.13[${PYTHON_USEDEP}]
		dev-python/service_identity[${PYTHON_USEDEP}]
		dev-python/idna[${PYTHON_USEDEP}]
		dev-python/pyserial[${PYTHON_USEDEP}]
		>=dev-python/constantly-15.1.0[${PYTHON_USEDEP}]
	)
"

PATCHES=(
	# Respect TWISTED_DISABLE_WRITING_OF_PLUGIN_CACHE variable.
	"${FILESDIR}/${PN}-16.5.0-respect_TWISTED_DISABLE_WRITING_OF_PLUGIN_CACHE.patch"
	"${FILESDIR}/test_main.patch"
	"${FILESDIR}/utf8_overrides.patch"
	"${FILESDIR}/${PN}-16.6.0-test-fixes.patch"
)

S=${WORKDIR}/${TWISTED_P}

python_prepare_all() {
	# disable tests that don't work in our sandbox
	# and other test failures due to our conditions
	if use test ; then
		# Remove since this is an upstream distribution test for making releases
		rm src/twisted/python/test/test_release.py || die "rm src/twisted/python/test/test_release.py FAILED"
	fi
	distutils-r1_python_prepare_all
}

python_compile() {
	if ! python_is_python3; then
		# Needed to make the sendmsg extension work
		# (see https://twistedmatrix.com/trac/ticket/5701 )
		local -x CFLAGS="${CFLAGS} -fno-strict-aliasing"
		local -x CXXFLAGS="${CXXFLAGS} -fno-strict-aliasing"
	fi

	distutils-r1_python_compile
}

python_test() {
	distutils_install_for_testing

	export EMERGE_TEST_OVERRIDE=1
	export UTF8_OVERRIDES=1
	# workaround for the eclass not installing the entry points
	# in the test environment.  copy the old 16.3.2 start script
	# to run the tests with
	cp "${FILESDIR}"/trial "${TEST_DIR}" || die
	chmod +x "${TEST_DIR}"/trial || die

	pushd "${TEST_DIR}" > /dev/null || die

	if ! "${TEST_DIR}"/trial twisted; then
		die "Tests failed with ${EPYTHON}"
	fi
	# due to an anomoly in the tests, python doesn't return the correct form
	# of the escape sequence. So run those test separately with a clean python interpreter
	export UTF8_OVERRIDES=0
	if ! "${TEST_DIR}"/trial twisted.test.test_twistd.DaemonizeTests; then
		die "DaemonizeTests failed with ${EPYTHON}"
	fi
	if ! "${TEST_DIR}"/trial twisted.test.test_reflect.SafeStrTests; then
		die "SafeStrTests failed with ${EPYTHON}"
	fi

	popd > /dev/null || die
}

python_install() {
	distutils-r1_python_install

	cd "${D%/}$(python_get_sitedir)" || die

	# own the dropin.cache so we don't leave orphans
	touch twisted/plugins/dropin.cache || die

	python_doscript "${WORKDIR}"/twisted-regen-cache
}

python_install_all() {
	distutils-r1_python_install_all

	newconfd "${FILESDIR}/twistd.conf" twistd
	newinitd "${FILESDIR}/twistd.init" twistd
}

python_postinst() {
	twisted-regen-cache || die
}

pkg_postinst() {
	python_foreach_impl python_postinst

	einfo "Install complete"
	if use test ; then
		einfo ""
		einfo "Some tests have been disabled during testing due to"
		einfo "known incompatibilities with the emerge sandboxes and/or"
		einfo "not runnable as the root user."
		einfo "For a complete test suite run on the code."
		einfo "Run the tests as a normal user for each python it is installed to."
		einfo "  ie:  $ python3.6 /usr/bin/trial twisted"
		einfo "There are a few known python-2.7 errors due to some unicode issues"
		einfo "which are different in Gentoo installed python-2.7"
	fi
}

python_postrm() {
	rm -f "${ROOT%/}$(python_get_sitedir)/twisted/plugins/dropin.cache" || die
}

pkg_postrm(){
	# if we're removing the last version, remove the cache file
	if [[ ! ${REPLACING_VERSIONS} ]]; then
		python_foreach_impl python_postrm
	fi
}
