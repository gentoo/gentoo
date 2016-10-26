# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
PYTHON_COMPAT=( python2_7 )
PYTHON_REQ_USE="threads(+)"

inherit eutils flag-o-matic twisted-r1

DESCRIPTION="An asynchronous networking framework written in Python"

KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~ppc ~ppc64 ~s390 ~sh ~x86 ~x86-fbsd ~ia64-hpux ~x86-interix ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE="crypt gtk serial test"

RDEPEND=">=dev-python/zope-interface-3.6.0[${PYTHON_USEDEP}]
	crypt? ( >=dev-python/pyopenssl-0.10[${PYTHON_USEDEP}]
		dev-python/service_identity[${PYTHON_USEDEP}] )
	gtk? ( dev-python/pygtk:2[${PYTHON_USEDEP}] )
	serial? ( dev-python/pyserial[${PYTHON_USEDEP}] )"
DEPEND="
	!dev-python/twisted
	test? ( ${RDEPEND} )
"

PATCHES=(
	# Respect TWISTED_DISABLE_WRITING_OF_PLUGIN_CACHE variable.
	"${FILESDIR}/${PN}-9.0.0-respect_TWISTED_DISABLE_WRITING_OF_PLUGIN_CACHE.patch"
)

python_prepare_all() {
	if [[ "${EUID}" -eq 0 ]]; then
		# Disable tests failing with root permissions.
		sed \
			-e "s/test_newPluginsOnReadOnlyPath/_&/" \
			-e "s/test_deployedMode/_&/" \
			-i twisted/test/test_plugin.py
	fi

	distutils-r1_python_prepare_all
}

python_compile() {
	if ! python_is_python3; then
		# Needed to make the sendmsg extension work
		# (see http://twistedmatrix.com/trac/ticket/5701 )
		local -x CFLAGS="${CFLAGS} -fno-strict-aliasing"
		local -x CXXFLAGS="${CXXFLAGS} -fno-strict-aliasing"
	fi

	distutils-r1_python_compile
}

python_test() {
	distutils_install_for_testing

	pushd "${TEST_DIR}"/lib > /dev/null || die

	# Skip broken tests.

	# http://twistedmatrix.com/trac/ticket/5375
	sed -e "/class ZshIntegrationTestCase/,/^$/d" -i twisted/scripts/test/test_scripts.py \
		|| die "sed failed"

	# Prevent it from pulling in plugins from already installed twisted packages.
	rm -f twisted/plugins/__init__.py

	# An empty file doesn't work because the tests check for doc strings in all packages.
	echo "'''plugins stub'''" > twisted/plugins/__init__.py || die

	# https://twistedmatrix.com/trac/ticket/6920 6921
	# Just re-exposing them to list a full list of deficits
#	sed -e 's:test_basicOperation:_&:' -i twisted/scripts/test/test_tap2deb.py || die
#	sed -e 's:test_inspectCertificate:_&:' -i twisted/test/test_sslverify.py || die

	# Requires twisted-web, twisted-lore and twisted-names, creating a circ. dep and fail even if installed.
	# test_loreDeprecation and test_exist failures appeared in version 14.0.0.
	# Possibly due to over taxing of the distutils_install_for_testing function
	rm -f twisted/python/test/test_release.py || die
	sed -e 's:test_loreDeprecation:_&:' -i twisted/test/test_twisted.py || die
	sed -e 's:test_exist:_&:' -i twisted/python/test/test_dist3.py || die

	# Requires connection to the network
	sed -e 's:test_multiListen:_&:' -i twisted/test/test_udp.py || die

	# Appeared in version 14.0.0; https://twistedmatrix.com/trac/ticket/7422; known failures
	# Upstream somewhat unreceptive
	# The last of these invokes a hang or a long delay
	sed -e 's:test_dataReceivedThrows:_&:' \
		-e 's:test_resumeProducingThrows:_&:' \
		-e 's:test_resumeProducingAbortLater:_&:' \
		-e 's:test_resumeProducingAbort:_&:' \
		-e 's:test_fullWriteBufferAfterByteExchange:_&:' \
		-i twisted/internet/test/test_tcp.py || die
	sed -e 's:test_logPrefix:_&:' -i twisted/internet/test/connectionmixins.py || die

	if ! "${TEST_DIR}"/scripts/trial twisted; then
		die "Tests failed with ${EPYTHON}"
	fi

	popd > /dev/null || die
}

python_install() {
	distutils-r1_python_install

	cd "${D%/}$(python_get_sitedir)" || die

	# create 'Twisted' egg wrt bug #299736
	local egg=( Twisted_Core*.egg-info )
	[[ -f ${egg[0]} ]] || die "Twisted_Core*.egg-info not found"
	ln -s "${egg[0]}" "${egg[0]/_Core/}" || die

	# own the dropin.cache so we don't leave orphans
	touch twisted/plugins/dropin.cache || die
}

python_install_all() {
	distutils-r1_python_install_all

	newconfd "${FILESDIR}/twistd.conf" twistd
	newinitd "${FILESDIR}/twistd.init" twistd
}
