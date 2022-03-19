# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7,8,9,10} )

inherit bash-completion-r1 cmake python-single-r1

DESCRIPTION="Build EAR generates a compilation database for clang tooling"
HOMEPAGE="https://github.com/rizsotto/Bear"
SRC_URI="https://github.com/rizsotto/Bear/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="amd64 ~ppc64 x86"
IUSE="test"

REQUIRED_USE="${PYTHON_REQUIRED_USE}"

DEPEND="test? (
	app-shells/bash
	$(python_gen_cond_dep '
		dev-python/lit[${PYTHON_USEDEP}]
	')
)"

RDEPEND="${PYTHON_DEPS}"

RESTRICT="!test? ( test )"

S="${WORKDIR}/${P^}"

src_configure() {
	local mycmakeargs=( -DUSE_SHELL_COMPLETION=OFF )
	cmake_src_configure
}

src_compile() {
	cmake_src_compile
	# need to fix it now, before tests are run
	python_fix_shebang "${BUILD_DIR}"/bear/bear
	python_fix_shebang test/functional/tools/cdb_diff.py
}

src_install() {
	cmake_src_install
	dobashcomp shell-completion/bash/bear
}

src_test() {
	if has sandbox ${FEATURES}; then
		ewarn "\'FEATURES=sandbox\' detected"
		ewarn "Bear overrides LD_PRELOAD and conflicts with gentoo sandbox"
		ewarn "Skipping tests"
	elif
		has usersandbox ${FEATURES}; then
		ewarn "\'FEATURES=usersandbox\' detected"
		ewarn "Skipping tests"
	elif
		has_version -b 'sys-devel/gcc-config[-native-symlinks]'; then
		ewarn "\'sys-devel/gcc-config[-native-symlinks]\' detected, tests call /usr/bin/cc directly (hardcoded)"
		ewarn "and will fail without generic cc symlink"
		ewarn "Skipping tests"
	else
		einfo "removing unwanted/unsupported/xfail tests"
		rm -v test/functional/cases/{end-to-end/scons.ft,intercept/cuda/successful_build.fts,run_pep8.ft} || die
		einfo "test may use optional tools if found: qmake gfortran"
		cmake_build check
	fi
}
