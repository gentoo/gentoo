# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5
PYTHON_COMPAT=( python2_7 python3_{4,5})
PYTHON_REQ_USE="threads(+)"
TWISTED_PN="Twisted"

inherit eutils flag-o-matic twisted-r1

DESCRIPTION="An asynchronous networking framework written in Python"
SRC_URI="http://twistedmatrix.com/Releases/${TWISTED_PN}"
SRC_URI="${SRC_URI}/${TWISTED_RELEASE}/${TWISTED_P}.tar.bz2"

# Dropped keywords due to new deps not keyworded
#KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~ppc ~ppc64 ~s390 ~sh ~x86 ~x86-fbsd ~ia64-hpux ~x86-interix ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
KEYWORDS="~amd64 ~ppc ~ppc64 ~x86"
IUSE="conch crypt http2 serial +soap test"

RDEPEND=">=dev-python/zope-interface-3.6.0[${PYTHON_USEDEP}]
	conch? (
		dev-python/gmpy[${PYTHON_USEDEP}]
		dev-python/pyasn1[${PYTHON_USEDEP}]
		>=dev-python/cryptography-0.9.1[${PYTHON_USEDEP}]
		>=dev-python/appdirs-1.4.0[${PYTHON_USEDEP}]
	)
	crypt? (
		>=dev-python/pyopenssl-0.13[${PYTHON_USEDEP}]
		dev-python/service_identity[${PYTHON_USEDEP}]
		dev-python/idna[${PYTHON_USEDEP}]
	)
	serial? ( dev-python/pyserial[${PYTHON_USEDEP}] )
	soap? ( $(python_gen_cond_dep 'dev-python/soappy[${PYTHON_USEDEP}]' python2_7) )
	http2? (
		>=dev-python/hyper-h2-2.3.0[${PYTHON_USEDEP}]
		<dev-python/hyper-h2-3.0[${PYTHON_USEDEP}]
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
	test? (
		dev-python/gmpy[${PYTHON_USEDEP}]
		dev-python/pyasn1[${PYTHON_USEDEP}]
		>=dev-python/cryptography-0.9.1[${PYTHON_USEDEP}]
		>=dev-python/appdirs-1.4.0[${PYTHON_USEDEP}]
		>=dev-python/pyopenssl-0.13[${PYTHON_USEDEP}]
		dev-python/service_identity[${PYTHON_USEDEP}]
		dev-python/idna[${PYTHON_USEDEP}]
		dev-python/pyserial[${PYTHON_USEDEP}]
	)
"

PATCHES=(
	# Respect TWISTED_DISABLE_WRITING_OF_PLUGIN_CACHE variable.
	"${FILESDIR}/${PN}-core-9.0.0-respect_TWISTED_DISABLE_WRITING_OF_PLUGIN_CACHE.patch"
)

python_prepare_all() {
	# Remove some tests known to fail due to the network sandbox
	rm -R twisted/pair/test/test_*.py || die "rm twisted/pair/test/test_*.py FAILED"
	# Possibly due to over taxing of the distutils_install_for_testing function
	rm twisted/python/test/test_release.py || die "rm twisted/python/test/test_release.py FAILED"
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

	if ! "${TEST_DIR}"/scripts/trial twisted; then
		die "Tests failed with ${EPYTHON}"
	fi

	popd > /dev/null || die
}

python_install() {
	distutils-r1_python_install

	cd "${D%/}$(python_get_sitedir)" || die

	# create 'Twisted' egg wrt bug #299736
	#local egg=( Twisted_Core*.egg-info )
	#[[ -f ${egg[0]} ]] || die "Twisted_Core*.egg-info not found"
	#ln -s "${egg[0]}" "${egg[0]/_Core/}" || die

	# own the dropin.cache so we don't leave orphans
	touch twisted/plugins/dropin.cache || die
}

python_install_all() {
	distutils-r1_python_install_all

	newconfd "${FILESDIR}/twistd.conf" twistd
	newinitd "${FILESDIR}/twistd.init" twistd
}

pkg_postrm(){
	# pre portage-2.3.2 release workaround for bug 595028
	cd "${HOME}"
	_distutils-r1_run_foreach_impl twisted-r1_update_plugin_cache
}
