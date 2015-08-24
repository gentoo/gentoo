# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"
PYTHON_COMPAT=( python2_7 )
PYTHON_REQ_USE="threads,ssl,xml"

inherit bash-completion-r1 distutils-r1 eutils flag-o-matic versionator

MY_P=${PN}-${PV}
SERIES=$(get_version_component_range 1-2)

DESCRIPTION="Bazaar is a next generation distributed version control system"
HOMEPAGE="http://bazaar-vcs.org/"
#SRC_URI="http://bazaar-vcs.org/releases/src/${MY_P}.tar.gz"
SRC_URI="https://launchpad.net/bzr/${SERIES}/${PV}/+download/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ~ia64 ~mips ppc ppc64 ~s390 ~sh ~sparc x86 ~amd64-fbsd ~x86-fbsd ~x86-interix ~amd64-linux ~arm-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~m68k-mint ~sparc-solaris"
IUSE="curl doc +sftp test"

RDEPEND="curl? ( dev-python/pycurl[${PYTHON_USEDEP}] )
	sftp? ( dev-python/paramiko[${PYTHON_USEDEP}] )"

DEPEND="test? (
		${RDEPEND}
		>=dev-python/pyftpdlib-0.7.0[${PYTHON_USEDEP}]
		dev-python/subunit
		>=dev-python/testtools-0.9.5[${PYTHON_USEDEP}]
	)"

S="${WORKDIR}/${MY_P}"

PATCHES=(
	"${FILESDIR}/${PN}-2.4.2-no-pyrex-citon.patch"
	"${FILESDIR}/${P}-sphinx-test-failures.patch"
)

python_configure_all() {
	# Generate the locales first to avoid a race condition.
	esetup.py build_mo
}

python_compile() {
	if [[ ${EPYTHON} != python3* ]]; then
		local CFLAGS=${CFLAGS}
		append-cflags -fno-strict-aliasing
	fi
	distutils-r1_python_compile
}

src_test() {
	# Race due to conflicting ports in
	# blackbox.test_serve.TestBzrServe.test_bzr_serve*.
	DISTUTILS_NO_PARALLEL_BUILD=1 distutils-r1_src_test
}

python_test() {
	# Some tests expect the usual pyc compiling behaviour.
	local -x PYTHONDONTWRITEBYTECODE

	# Define tests which are known to fail below.
	local skip_tests="("
	# https://bugs.launchpad.net/bzr/+bug/850676
	skip_tests+="per_transport.TransportTests.test_unicode_paths.*"
	skip_tests+=")"
	if [[ -n ${skip_tests} ]]; then
		einfo "Skipping tests known to fail: ${skip_tests}"
	fi

	LC_ALL="C" "${PYTHON}" bzr --no-plugins selftest -v \
		${skip_tests:+-x} "${skip_tests}" || die "Tests fail with ${EPYTHON}"
}

python_install_all() {
	distutils-r1_python_install_all

	# Fixup manpages manually; passing --install-data causes locales to be
	# installed in /usr/share/share/locale
	dodir /usr/share
	mv "${ED%/}"/usr/{man,share/man} || die

	dodoc doc/*.txt

	if use doc; then
		docinto developers
		dodoc -r doc/developers/* || die
		for doc in mini-tutorial tutorials user-{guide,reference}; do
			docinto ${doc}
			dodoc -r doc/en/${doc}/* || die
		done
	fi

	dobashcomp contrib/bash/bzr || die
}
