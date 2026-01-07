# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# This is just a stub for tooling, see the IUSE hack below. Don't panic
# if the array here doesn't contain the latest impl. If you can't use a
# new impl., it's likely because it's a stable-masked flag.
PYTHON_COMPAT=( python3_{11..14} pypy3_11 )

inherit python-any-r1

DESCRIPTION="Python script wrapper"
HOMEPAGE="https://github.com/projg2/python-exec/"
SRC_URI="https://github.com/projg2/python-exec/releases/download/v${PV}/${P}.tar.bz2"

LICENSE="BSD-2"
SLOT="2"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 ~sparc x86 ~arm64-macos ~x64-macos ~x64-solaris"
# Internal Python project hack.  Do not copy it.  Ever.
IUSE="${_PYTHON_ALL_IMPLS[@]/#/python_targets_} +native-symlinks test"
RESTRICT="!test? ( test )"

RDEPEND="
	dev-lang/python-exec-conf
	!<=dev-lang/python-2.7.18-r3:2.7
"
BDEPEND="
	test? (
		$(python_gen_any_dep 'dev-python/pytest[${PYTHON_USEDEP}]')
	)
"

python_check_deps() {
	python_has_version -b "dev-python/pytest[${PYTHON_USEDEP}]"
}

pkg_setup() {
	use test && python-any-r1_pkg_setup
}

src_configure() {
	local pyimpls=() i EPYTHON
	for i in "${_PYTHON_ALL_IMPLS[@]}"; do
		if use "python_targets_${i}"; then
			_python_export "${i}" EPYTHON
			pyimpls+=( "${EPYTHON}" )
		fi
	done

	local myconf=(
		--with-fallback-path="${EPREFIX}/usr/local/sbin:${EPREFIX}/usr/local/bin:${EPREFIX}/usr/sbin:${EPREFIX}/usr/bin:${EPREFIX}/sbin:${EPREFIX}/bin"
		--with-python-impls="${pyimpls[*]}"
	)

	econf "${myconf[@]}"
}

src_test() {
	local -x PYTEST_DISABLE_PLUGIN_AUTOLOAD=1
	default
}

src_install() {
	default

	if use native-symlinks; then
		local programs=( python python3 )
		local scripts=( python-config python3-config 2to3 idle pydoc pyvenv )

		local f
		for f in "${programs[@]}"; do
			# symlink the C wrapper for python to avoid shebang recursion
			# bug #568974
			dosym python-exec2c /usr/bin/"${f}"
		done
		for f in "${scripts[@]}"; do
			# those are python scripts (except for new python-configs)
			# so symlink them via the python wrapper
			dosym ../lib/python-exec/python-exec2 /usr/bin/"${f}"
		done
	fi
}
