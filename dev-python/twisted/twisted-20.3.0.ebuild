# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6,7,8,9} )
PYTHON_REQ_USE="threads(+)"

inherit distutils-r1 virtualx

TWISTED_PN="Twisted"
TWISTED_P="${TWISTED_PN}-${PV}"
TWISTED_RELEASE=$(ver_cut 1-2)

DESCRIPTION="An asynchronous networking framework written in Python"
HOMEPAGE="https://www.twistedmatrix.com/trac/"
SRC_URI="https://twistedmatrix.com/Releases/${TWISTED_PN}"
SRC_URI="${SRC_URI}/${TWISTED_RELEASE}/${TWISTED_P}.tar.bz2
	https://dev.gentoo.org/~mgorny/dist/twisted-regen-cache.gz"

KEYWORDS="~alpha amd64 arm arm64 ~ia64 ~mips ~ppc ppc64 ~s390 sparc x86 ~amd64-linux ~x86-linux"

LICENSE="MIT"
SLOT="0"
IUSE="conch crypt http2 serial test"
RESTRICT="!test? ( test )"

RDEPEND="
	>=dev-python/attrs-19.2.0[${PYTHON_USEDEP}]
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
	local PATCHES=(
		"${FILESDIR}"/twisted-20.3.0-py38-cgi.patch
		"${FILESDIR}"/twisted-20.3.0-py38-hmac.patch
		"${FILESDIR}"/twisted-20.3.0-py39-b64.patch
		"${FILESDIR}"/twisted-20.3.0-py39-combined.patch
	)

	# upstream test for making releases; not very useful and requires
	# sphinx (including on py2)
	rm src/twisted/python/test/test_release.py || die

	# Conch doesn't work with latest >=OpenSSH 7.6
	#   - https://twistedmatrix.com/trac/ticket/9311
	#   - https://twistedmatrix.com/trac/ticket/9515
	rm src/twisted/conch/test/test_ckeygen.py || die
	rm src/twisted/conch/test/test_conch.py || die
	rm src/twisted/conch/test/test_cftp.py || die

	# puts system in EMFILE state, then the exception handler may fail
	# trying to open more files due to some gi magic
	sed -e '/SKIP_EMFILE/s:None:"Fails on non-pristine systems":' \
		-i src/twisted/internet/test/test_tcp.py || die

	# multicast tests fail within network-sandbox
	sed -e 's:test_joinLeave:_&:' \
		-e 's:test_loopback:_&:' \
		-e 's:test_multiListen:_&:' \
		-e 's:test_multicast:_&:' \
		-i src/twisted/test/test_udp.py || die

	# accesses /dev/net/tun
	sed -e '/class RealDeviceTestsMixin/a\
    skip = "Requires extra permissions"' \
		-i src/twisted/pair/test/test_tuntap.py || die

	# TODO: figure it out, probably doesn't accept DST date here
	sed -e 's:test_getTimezoneOffsetWithoutDaylightSavingTime:_&:' \
		-i src/twisted/test/test_log.py || die

	# TODO: failures specific to Python 2
	sed -e 's:testLookupProcNetTcp:_&:' \
		-i src/twisted/test/test_ident.py || die
	sed -e 's:test_loggingFactoryOpensLogfileAutomatically:_&:' \
		-i src/twisted/test/test_policies.py || die

	distutils-r1_python_prepare_all
}

src_test() {
	virtx distutils-r1_src_test
}

python_test() {
	# TODO: upstream seems to override our build paths
	distutils_install_for_testing

	"${EPYTHON}" -m twisted.trial twisted ||
		die "Tests failed with ${EPYTHON}"
}

python_install() {
	distutils-r1_python_install

	cd "${D}$(python_get_sitedir)" || die

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
	rm -f "${ROOT}$(python_get_sitedir)/twisted/plugins/dropin.cache" || die
}

pkg_postrm() {
	# if we're removing the last version, remove the cache file
	if [[ ! ${REPLACING_VERSIONS} ]]; then
		python_foreach_impl python_postrm
	fi
}
