# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

DESCRIPTION="eGenix utils for Python"
HOMEPAGE="https://www.egenix.com/products/python/mxBase https://pypi.org/project/egenix-mx-base/"
SRC_URI="https://downloads.egenix.com/python/${P}.tar.gz"

LICENSE="eGenixPublic-1.1"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~x86-solaris"
IUSE=""
# Correct broken tests
PATCHES=( "${FILESDIR}"/${PN}-3.2.6-tests.patch )

python_prepare_all() {
	# Don't install documentation in site-packages directories.
	sed -e "/\.pdf/d" -i egenix_mx_base.py || die

	distutils-r1_python_prepare_all
}

python_compile() {
	if ! python_is_python3; then
		local -x CFLAGS="${CFLAGS} -fno-strict-aliasing"
	fi
	distutils-r1_python_compile
}

python_test() {
	local t

	while IFS= read -r -d '' t
	do
		"${PYTHON}" "${t}" || die "${t} failed with ${EPYTHON}"
	done < <(find -name test.py -print0)
}

python_install() {
	local f dest=${D}$(python_get_includedir)/mx

	distutils-r1_python_install \
		build --build-platlib "${BUILD_DIR}"/lib

	mkdir -p "${dest}" || die
	while IFS= read -r -d '' f
	do
		mv -f "${f}" "${dest}" || die
	done < <(find "${D}$(python_get_sitedir)/mx" -type f -name "*.h" -print0)
}

python_install_all() {
	local f

	distutils-r1_python_install_all

	dohtml -a html -r mx
	while IFS= read -r -d '' f
	do
		dodoc "${f}"
	done < <(find -name '*.pdf' -print0)
}
