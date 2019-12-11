# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
PYTHON_COMPAT=( python2_7 )
PYTHON_REQ_USE="threads,ssl,xml"

MY_P="${PN}-${PV}"

DESCRIPTION="Bazaar is a next generation distributed version control system"
HOMEPAGE="http://bazaar-vcs.org/"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 arm arm64 hppa ia64 ~mips ppc ppc64 ~s390 ~sh sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~m68k-mint ~sparc-solaris"
IUSE="curl doc +sftp test"
PLOCALES="ar ast bs ca cs de el en_AU en_GB es fa fo fr gl he id it ja ko ms my nb nl oc pl pt_BR ro ru sco si sk sr sv tr ug uk vi zh_CN"

inherit bash-completion-r1 distutils-r1 eutils flag-o-matic versionator l10n
SERIES=$(get_version_component_range 1-2)
SRC_URI="https://launchpad.net/bzr/${SERIES}/${PV}/+download/${MY_P}.tar.gz"

RDEPEND="curl? ( dev-python/pycurl[${PYTHON_USEDEP}] )
	sftp? ( dev-python/paramiko[${PYTHON_USEDEP}] )"

DEPEND="test? (
		${RDEPEND}
		>=dev-python/pyftpdlib-0.7.0[${PYTHON_USEDEP}]
		dev-python/subunit
		>=dev-python/testtools-0.9.5[${PYTHON_USEDEP}]
	)"

S="${WORKDIR}/${MY_P}"

# Fails tests bug#487216
# Upstream is not exactly keen on fixing it
RESTRICT="test"

python_configure_all() {
	rm_loc() {
		rm "${S}"/po/$1.po || die
	}
	l10n_for_each_disabled_locale_do rm_loc
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
		dodoc -r doc/developers/*
		for doc in mini-tutorial tutorials user-{guide,reference}; do
			docinto ${doc}
			dodoc -r doc/en/${doc}/*
		done
	fi

	dobashcomp contrib/bash/bzr || die
}
