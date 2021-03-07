# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit python-utils-r1

DESCRIPTION="Python script wrapper"
HOMEPAGE="https://github.com/mgorny/python-exec/"
SRC_URI="https://github.com/mgorny/python-exec/releases/download/v${PV}/${P}.tar.bz2"

LICENSE="BSD-2"
SLOT="2"
KEYWORDS="~alpha amd64 ~arm ~arm64 hppa ~ia64 ~m68k ~mips ppc ppc64 ~riscv s390 sparc x86 ~x64-cygwin ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
# Internal Python project hack.  Do not copy it.  Ever.
IUSE="${_PYTHON_ALL_IMPLS[@]/#/python_targets_} +native-symlinks"

RDEPEND="
	dev-lang/python-exec-conf
	!<=dev-lang/python-2.7.18-r3:2.7"

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
