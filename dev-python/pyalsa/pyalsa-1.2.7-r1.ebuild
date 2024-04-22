# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_EXT=1
DISTUTILS_USE_PEP517=setuptools
# py3.12: https://github.com/alsa-project/alsa-python/issues/8
PYTHON_COMPAT=( python3_{10..11} )

inherit distutils-r1

DESCRIPTION="Python bindings for ALSA library"
HOMEPAGE="https://alsa-project.org/wiki/Main_Page"
SRC_URI="https://www.alsa-project.org/files/pub/pyalsa/${P}.tar.bz2"

LICENSE="LGPL-2.1+"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm64 ~hppa ~ia64 ~mips ppc ppc64 ~riscv sparc x86"
# Needs access to system's alsa configuration/devices
RESTRICT="test"

DEPEND="
	media-libs/alsa-lib
"
RDEPEND="
	${DEPEND}
"
BDEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]
"

PATCHES=(
	"${FILESDIR}/${PN}-1.1.6-no-build-symlinks.patch"
)

python_test() {
	cd "${T}" || die

	shopt -s nullglob
	local test
	local failed
	for test in "${S}"/test/*.py ; do
		${EPYTHON} "${test}" || {
			eerror "${test} failed with ${EPYTHON}"
			failed=1
			break
		}
	done
	shopt -u nullglob

	if [[ ${failed} -eq 1 ]] ; then
		die "${test} failed with ${EPYTHON}"
	fi
}
