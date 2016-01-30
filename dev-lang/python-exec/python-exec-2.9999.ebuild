# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

#if LIVE
EGIT_REPO_URI="https://bitbucket.org/mgorny/${PN}.git"

inherit autotools git-r3
#endif

# Kids, don't do this at home!
inherit python-utils-r1
PYTHON_COMPAT=( "${_PYTHON_ALL_IMPLS[@]}" )

# Inherited purely to have PYTHON_TARGET flags which will satisfy USE
# dependencies and trigger necessary rebuilds.
inherit python-r1

DESCRIPTION="Python script wrapper"
HOMEPAGE="https://bitbucket.org/mgorny/python-exec/"
SRC_URI="https://www.bitbucket.org/mgorny/${PN}/downloads/${P}.tar.bz2"

LICENSE="BSD-2"
SLOT="2"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~ppc-aix ~amd64-fbsd ~x86-fbsd ~x64-freebsd ~x86-freebsd ~amd64-linux ~arm-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~m68k-mint ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE=""

# eselect-python because of /usr/bin/python* collisions
# python versions because of missing $scriptdir/python* symlinks
RDEPEND="
	!<app-eselect/eselect-python-20160206
	!<dev-lang/python-2.7.10-r4:2.7
	!<dev-lang/python-3.3.5-r4:3.3
	!<dev-lang/python-3.4.3-r4:3.4
	!<dev-lang/python-3.5.0-r3:3.5"

#if LIVE
KEYWORDS=
SRC_URI=

src_prepare() {
	eautoreconf
}
#endif

src_configure() {
	local pyimpls=() i EPYTHON
	for i in "${PYTHON_COMPAT[@]}"; do
		python_export "${i}" EPYTHON
		pyimpls+=( "${EPYTHON}" )
	done

	local myconf=(
		--with-eprefix="${EPREFIX}"
		--with-python-impls="${pyimpls[*]}"
	)

	econf "${myconf[@]}"
}

src_install() {
	default

	local f
	for f in python{,2,3}; do
		# can't use symlinks here since random stuff
		# loves to do readlink on sys.executable...
		newbin python-exec2-c "${f}"
	done
	for f in python{,2,3}-config 2to3 idle pydoc pyvenv; do
		dosym ../lib/python-exec/python-exec2 /usr/bin/"${f}"
	done
}

pkg_preinst() {
	local py

	# Copy python[23] selection from the old format (symlink)
	for py in 2 3; do
		if [[ -L ${EROOT}/usr/bin/python${py} ]]; then
			local target=$(readlink "${EROOT}/usr/bin/python${py}")

			# check if it's actually old eselect symlink
			if [[ ${target} == python?.? ]]; then
				einfo "Preserving Python${py} as ${target}"
				echo "${target}" > "${EROOT}/etc/env.d/python/python${py}" || die
			fi
		fi
	done
}
