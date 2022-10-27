# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{8..11} pypy3 )
PYTHON_REQ_USE="threads(+)"

inherit distutils-r1 virtualx

DESCRIPTION="An asynchronous networking framework written in Python"
HOMEPAGE="https://www.twistedmatrix.com/trac/"
SRC_URI="
	https://github.com/twisted/twisted/archive/${P}.tar.gz -> ${P}.gh.tar.gz
	https://dev.gentoo.org/~mgorny/dist/twisted-regen-cache.gz
"
S=${WORKDIR}/${PN}-${P}

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~loong ~m68k ppc ppc64 ~riscv ~s390 sparc x86"
IUSE="conch http2 serial ssl test"
RESTRICT="!test? ( test )"

RDEPEND="
	>=dev-python/attrs-19.2.0[${PYTHON_USEDEP}]
	>=dev-python/automat-0.8.0[${PYTHON_USEDEP}]
	>=dev-python/constantly-15.1[${PYTHON_USEDEP}]
	>=dev-python/hyperlink-17.1.1[${PYTHON_USEDEP}]
	>=dev-python/incremental-21.3.0[${PYTHON_USEDEP}]
	>=dev-python/typing-extensions-3.6.5[${PYTHON_USEDEP}]
	>=dev-python/zope-interface-4.4.2[${PYTHON_USEDEP}]
	conch? (
		>=dev-python/appdirs-1.4.0[${PYTHON_USEDEP}]
		>=dev-python/bcrypt-3.0.0[${PYTHON_USEDEP}]
		>=dev-python/cryptography-2.6[${PYTHON_USEDEP}]
		dev-python/pyasn1[${PYTHON_USEDEP}]
	)
	http2? (
		<dev-python/h2-5.0.0[${PYTHON_USEDEP}]
		>=dev-python/h2-3.0.0[${PYTHON_USEDEP}]
		<dev-python/priority-2.0[${PYTHON_USEDEP}]
		>=dev-python/priority-1.1.0[${PYTHON_USEDEP}]
	)
	serial? (
		>=dev-python/pyserial-3.0[${PYTHON_USEDEP}]
	)
	ssl? (
		>=dev-python/pyopenssl-21.0.0[${PYTHON_USEDEP}]
		>=dev-python/service_identity-18.1.0[${PYTHON_USEDEP}]
		>=dev-python/idna-2.4[${PYTHON_USEDEP}]
	)
"
BDEPEND="
	>=dev-python/incremental-21.3.0[${PYTHON_USEDEP}]
	test? (
		$(python_gen_cond_dep '
			>=dev-python/appdirs-1.4.0[${PYTHON_USEDEP}]
			>=dev-python/constantly-15.1.0[${PYTHON_USEDEP}]
			>=dev-python/cython-test-exception-raiser-1.0.2[${PYTHON_USEDEP}]
			>=dev-python/idna-2.4[${PYTHON_USEDEP}]
			dev-python/pyasn1[${PYTHON_USEDEP}]
			>=dev-python/pyhamcrest-1.9.0[${PYTHON_USEDEP}]
			>=dev-python/pyserial-3.0[${PYTHON_USEDEP}]
			net-misc/openssh
			conch? (
				>=dev-python/bcrypt-3.0.0[${PYTHON_USEDEP}]
				>=dev-python/cryptography-2.6[${PYTHON_USEDEP}]
			)
			ssl? (
				>=dev-python/pyopenssl-21.0.0[${PYTHON_USEDEP}]
				>=dev-python/service_identity-18.1.0[${PYTHON_USEDEP}]
			)
		' python3_{8..10} pypy3)
		$(python_gen_cond_dep '
			dev-python/gmpy[${PYTHON_USEDEP}]
		' python3_{8..10})
	)
"

PATCHES=(
	# https://twistedmatrix.com/trac/ticket/10200
	"${FILESDIR}/${PN}-22.1.0-force-gtk3.patch"
)

python_prepare_all() {
	# upstream test for making releases; not very useful and requires
	# sphinx (including on py2)
	rm src/twisted/python/test/test_release.py || die

	# puts system in EMFILE state, then the exception handler may fail
	# trying to open more files due to some gi magic
	sed -e '/SKIP_EMFILE/s:False:True:' \
		-i src/twisted/internet/test/test_tcp.py || die

	# multicast tests fail within network-sandbox
	sed -e 's:test_joinLeave:_&:' \
		-e 's:test_loopback:_&:' \
		-e 's:test_multiListen:_&:' \
		-e 's:test_multicast:_&:' \
		-i src/twisted/test/test_udp.py || die

	# These tests rely on warnings which seems work unreliably between python versions
	sed -e 's:test_currentEUID:_&:' \
		-e 's:test_currentUID:_&:' -i src/twisted/python/test/test_util.py || die

	# broken by new expat
	sed -e 's:test_namespaceWithWhitespace:_&:' \
		-i src/twisted/words/test/test_domish.py || die

	distutils-r1_python_prepare_all
}

src_test() {
	# the test suite handles missing file & failing ioctl()s gracefully
	# but not permission errors from sandbox
	addwrite /dev/net/tun
	virtx distutils-r1_src_test
}

python_test() {
	# please keep in sync with python_gen_cond_dep!
	if ! has "${EPYTHON}" python3_{8..10} pypy3; then
		einfo "Skipping tests on ${EPYTHON} (xfail)"
		return
	fi

	"${EPYTHON}" -m twisted.trial twisted ||
		die "Tests failed with ${EPYTHON}"
}

python_install() {
	distutils-r1_python_install

	# own the dropin.cache so we don't leave orphans
	> "${D}$(python_get_sitedir)"/twisted/plugins/dropin.cache || die

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
	if [[ -z ${ROOT} ]]; then
		python_foreach_impl python_postinst
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
