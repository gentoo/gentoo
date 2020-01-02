# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python2_7 python3_{5,6,7} )
PYTHON_REQ_USE="threads(+)"

inherit distutils-r1

TWISTED_PN="Twisted"
TWISTED_P="${TWISTED_PN}-${PV}"
TWISTED_RELEASE=$(ver_cut 1-2)

DESCRIPTION="An asynchronous networking framework written in Python"
HOMEPAGE="https://www.twistedmatrix.com/trac/"
SRC_URI="https://twistedmatrix.com/Releases/${TWISTED_PN}"
SRC_URI="${SRC_URI}/${TWISTED_RELEASE}/${TWISTED_P}.tar.bz2
	https://dev.gentoo.org/~mgorny/dist/twisted-regen-cache.gz"

KEYWORDS="amd64 ~arm arm64 ~mips ~s390 ~sh ~sparc ~amd64-linux ~x86-linux"

LICENSE="MIT"
SLOT="0"
IUSE="conch crypt http2 serial +soap test"
RESTRICT="!test? ( test )"

RDEPEND="
	>=dev-python/attrs-17.4.0[${PYTHON_USEDEP}]
	>=dev-python/automat-0.3.0[${PYTHON_USEDEP}]
	>=dev-python/constantly-15.1.0[${PYTHON_USEDEP}]
	>=dev-python/hyperlink-17.1.1[${PYTHON_USEDEP}]
	>=dev-python/incremental-16.10.1[${PYTHON_USEDEP}]
	>=dev-python/pyhamcrest-1.9.0[${PYTHON_USEDEP}]
	>=dev-python/zope-interface-4.4.2[${PYTHON_USEDEP}]
	conch? (
		dev-python/pyasn1[${PYTHON_USEDEP}]
		>=dev-python/cryptography-1.5.0[${PYTHON_USEDEP}]
		>=dev-python/appdirs-1.4.0[${PYTHON_USEDEP}]
	)
	crypt? (
		>=dev-python/pyopenssl-16.0.0[${PYTHON_USEDEP}]
		dev-python/service_identity[${PYTHON_USEDEP}]
		>=dev-python/idna-0.6[${PYTHON_USEDEP}]
	)
	serial? ( >=dev-python/pyserial-3.0[${PYTHON_USEDEP}] )
	soap? ( $(python_gen_cond_dep 'dev-python/soappy[${PYTHON_USEDEP}]' python2_7) )
	http2? (
		>=dev-python/hyper-h2-3.0.0[${PYTHON_USEDEP}]
		<dev-python/hyper-h2-4.0.0[${PYTHON_USEDEP}]
		>=dev-python/priority-1.1.0[${PYTHON_USEDEP}]
		<dev-python/priority-2.0[${PYTHON_USEDEP}]
	)
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
	dev-python/bcrypt
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
		net-misc/openssh
	)
"

S=${WORKDIR}/${TWISTED_P}

python_prepare_all() {
	# No allowed tests are garaunteed to work on py3.5 or py3.8
	if use test ; then
		# Remove since this is an upstream distribution test for making releases
		rm src/twisted/python/test/test_release.py || die "rm src/twisted/python/test/test_release.py FAILED"

		# Remove these as they are known to fail -- fix (py2.7 - py3.6)
		rm src/twisted/conch/test/test_ckeygen.py || die "rm src/twisted/conch/test/test_ckeygen.py FAILED"
		rm src/twisted/pair/test/test_tuntap.py || die "rm src/twisted/pair/test/test_tuntap.py FAILED"
		rm src/twisted/test/test_log.py || die "rm src/twisted/test/test_log.py FAILED"

		# This test fails only on py3.7
		rm src/twisted/internet/test/test_process.py || die " rm src/twisted/internet/test/test_process.py FAILED"
	fi
	distutils-r1_python_prepare_all
}

python_test() {
	distutils_install_for_testing

	# workaround for the eclass not installing the entry points
	# in the test environment.  copy the old 16.3.2 start script
	# to run the tests with
	cp "${FILESDIR}"/trial "${TEST_DIR}" || die
	chmod +x "${TEST_DIR}"/trial || die

	pushd "${TEST_DIR}" > /dev/null || die

	if ! "${TEST_DIR}"/trial twisted; then
		die "Tests failed with ${EPYTHON}"
	fi

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

	cd "${D%}$(python_get_sitedir)" || die

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
	fi
}

python_postrm() {
	rm -f "${ROOT%}$(python_get_sitedir)/twisted/plugins/dropin.cache" || die
}

pkg_postrm(){
	# if we're removing the last version, remove the cache file
	if [[ ! ${REPLACING_VERSIONS} ]]; then
		python_foreach_impl python_postrm
	fi
}
