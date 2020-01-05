# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python{2_7,3_6} )

inherit vim-plugin python-single-r1

DESCRIPTION="vim plugin: easy and fast outlining"
HOMEPAGE="https://github.com/vimoutliner/vimoutliner"
SRC_URI="https://github.com/${PN}/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
LICENSE="GPL-2"
KEYWORDS="~amd64 ~x86"

REQUIRED_USE="${PYTHON_REQUIRED_USE}"

VIM_PLUGIN_HELPFILES="vimoutliner"
VIM_PLUGIN_MESSAGES="filetype"

PATCHES=( "${FILESDIR}/${P}-fix-shebangs.patch" )

RDEPEND="${PYTHON_DEPS}
	dev-python/autopep8[${PYTHON_USEDEP}]"

pkg_setup() {
	python-single-r1_pkg_setup
}

src_prepare() {
	default
	sed -i -e '/^if exists/,/endif/d' ftdetect/vo_base.vim || die
	sed -i -e 's/g:vo_modules2load/g:vo_modules_load/' vimoutliner/vimoutlinerrc || die
	rm -v install.sh || die
	find "${S}" -type f -exec chmod a+r {} \; || die
}

src_compile() {
	local pyscript _pyscript
	for pyscript in $(find "${S}" -type f -name \*.py); do
		_pyscript=$(basename "${pyscript}")
		einfo "Processing ${_pyscript}"
		sed -i -e 's#[ \t]*$##g;' "${pyscript}" || die
		2to3 --no-diffs -w -n "${pyscript}" 2> /dev/null || die
		autopep8 -i "${pyscript}" || die
		python_fix_shebang -q "${pyscript}" || die
		eend $?
	done
}
