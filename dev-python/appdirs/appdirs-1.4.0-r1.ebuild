# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

PYTHON_COMPAT=( python2_7 python3_{4,5} pypy pypy3 )

inherit distutils-r1

DESCRIPTION="Module for determining appropriate platform-specific dirs"
HOMEPAGE="https://github.com/ActiveState/appdirs"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE=""

# api.doctests is missing in the dist zipfile
# and the 'internal' doctest does nothing
RESTRICT=test

PATCHES=( "${FILESDIR}"/${P}-distutils.patch )

python_test() {
	cd test || die
	"${PYTHON}" test.py \
		|| die "Tests fail with ${EPYTHON}"
}

[[ ${PV} == 1.4.0 ]] || die "Please remove pkg_preinst from the ebuild"
pkg_preinst() {
	_remove_egg_info() {
		local pyver="$("${PYTHON}" -c 'import sys; print(sys.version[:3])')"
		local egginfo="${ROOT%/}$(python_get_sitedir)/${P}-py${pyver}.egg-info"
		if [[ -d ${egginfo} ]]; then
			einfo "Removing ${egginfo}"
			rm -r "${egginfo}" || die
		fi
	}
	python_foreach_impl _remove_egg_info
}
