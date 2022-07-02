# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( pypy3 python3_{8..11} )

inherit distutils-r1

MY_PN="${PN//-/.}"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="C-based reader/scanner and emitter for dev-python/ruamel-yaml"
HOMEPAGE="
	https://pypi.org/project/ruamel.yaml.clib/
	https://sourceforge.net/projects/ruamel-yaml-clib/
"
# Lacks .pyx files for cythonizing for py3.11
#SRC_URI="mirror://pypi/${MY_PN:0:1}/${MY_PN}/${MY_P}.tar.gz"
SRC_URI="mirror://sourceforge/ruamel-dl-tagged-releases/${MY_P}.tar.xz"
S=${WORKDIR}/${MY_P}

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 arm arm64 ~hppa ~ia64 ppc ppc64 ~riscv sparc x86"

BDEPEND="dev-python/cython[${PYTHON_USEDEP}]"

src_configure() {
	local cython_tmp_dir="${T}"/ruamel.yaml.clib
	local base_name="_ruamel_yaml" || die

	# Needed to recythonise for Python 3.11
	# Can likely drop after next release (after 0.2.6)
	rm ${base_name}.c || die

	mkdir "${cython_tmp_dir}" || die
	mv ${base_name}.pyx "${cython_tmp_dir}/" || die
	cythonize -3 "${cython_tmp_dir}"/${base_name}.pyx || die
	mv ${cython_tmp_dir}/* . || die
	rmdir ${cython_tmp_dir} || die
}
