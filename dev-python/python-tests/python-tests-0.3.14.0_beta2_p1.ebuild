# Copyright 2024-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_14t )
VERIFY_SIG_METHOD=sigstore

inherit python-r1 verify-sig

REAL_PV=${PV#0.}
MY_PV=${REAL_PV/_beta/b}
MY_P="Python-${MY_PV%_p*}"
PYVER=$(ver_cut 2-3)t
PATCHSET="python-gentoo-patches-${MY_PV}"

DESCRIPTION="Test modules from dev-lang/python"
HOMEPAGE="
	https://www.python.org/
	https://github.com/python/cpython/
"
SRC_URI="
	https://www.python.org/ftp/python/${REAL_PV%%_*}/${MY_P}.tar.xz
	https://dev.gentoo.org/~mgorny/dist/python/${PATCHSET}.tar.xz
	verify-sig? (
		https://www.python.org/ftp/python/${REAL_PV%%_*}/${MY_P}.tar.xz.sigstore
	)
"
S="${WORKDIR}/${MY_P}/Lib"

LICENSE="PSF-2"
SLOT="${PYVER}"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~loong ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86"
# enable by default to help CI handle it (we have no additional deps)
IUSE="+python_targets_${PYTHON_COMPAT[0]}"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="
	${PYTHON_DEPS}
	~dev-lang/python-${PV}:${PYVER}
"
BDEPEND="
	${PYTHON_DEPS}
"

# https://www.python.org/downloads/metadata/sigstore/
VERIFY_SIG_CERT_IDENTITY=hugo@python.org
VERIFY_SIG_CERT_OIDC_ISSUER=https://github.com/login/oauth

src_unpack() {
	if use verify-sig; then
		verify-sig_verify_detached "${DISTDIR}"/${MY_P}.tar.xz{,.sigstore}
	fi
	default
}

src_prepare() {
	local PATCHES=(
		"${WORKDIR}/${PATCHSET}"
	)

	cd .. || die
	default
}

src_install() {
	python_setup
	# keep in sync with TESTSUBDIRS in Makefile.pre.in
	python_moduleinto "/usr/lib/python${PYVER}"
	python_domodule test
	python_moduleinto "/usr/lib/python${PYVER}/idlelib"
	python_domodule idlelib/idle_test
}
