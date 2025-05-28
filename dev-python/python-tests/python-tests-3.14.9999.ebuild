# Copyright 2024-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_14 )

inherit git-r3 python-r1

PYVER=$(ver_cut 1-2)
PATCHSET="python-gentoo-patches-3.14.0b1"

DESCRIPTION="Test modules from dev-lang/python"
HOMEPAGE="
	https://www.python.org/
	https://github.com/python/cpython/
"
SRC_URI="
	https://dev.gentoo.org/~mgorny/dist/python/${PATCHSET}.tar.xz
"
EGIT_REPO_URI="https://github.com/python/cpython.git"
EGIT_BRANCH=${PYVER}
S="${WORKDIR}/${P}/Lib"

LICENSE="PSF-2"
SLOT="${PYVER}"
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

src_unpack() {
	git-r3_src_unpack
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
