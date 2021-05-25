# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python3_{7..9} )

inherit python-single-r1 vim-plugin vcs-snapshot

# Commit Date: 1 Mar 2018
COMMIT="4f12628247940d98eedd594961695dc504261058"

DESCRIPTION="Vim plugin for easy and fast outlining"
HOMEPAGE="https://github.com/vimoutliner/vimoutliner"
SRC_URI="https://github.com/vimoutliner/vimoutliner/archive/${COMMIT}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
KEYWORDS="amd64 ~ia64 ppc sparc x86"

REQUIRED_USE="${PYTHON_REQUIRED_USE}"

VIM_PLUGIN_HELPFILES="vimoutliner"
VIM_PLUGIN_MESSAGES="filetype"

RDEPEND="
	${PYTHON_DEPS}
	$(python_gen_cond_dep 'dev-python/autopep8[${PYTHON_MULTI_USEDEP}]')
"

DEPEND="${RDEPEND}"

DOCS=( README CHANGELOG TODO.otl )

src_prepare() {
	default

	sed -e '1s:^:#!/usr/bin/python\n:' \
		-i "${S}"/vimoutliner/scripts/otl2latex/otl2latex.py || die
	find "${S}" -type f -exec chmod a+r {} \; || die
}

src_compile() {
	local pyscript _pyscript
	for pyscript in $(find "${S}" -type f -name \*.py); do
		_pyscript=$(basename "${pyscript}")
		[[ ${_pyscript} == "otl.py" ]] && continue
		2to3 -w -n --no-diffs "${pyscript}" >& /dev/null || die
		python_fix_shebang -f -q "${pyscript}"
	done
}
