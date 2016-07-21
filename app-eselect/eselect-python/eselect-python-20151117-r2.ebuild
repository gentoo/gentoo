# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

if [[ ${PV} == "99999999" ]] ; then
	inherit autotools git-r3
	EGIT_REPO_URI="git://anongit.gentoo.org/proj/${PN}.git"
else
	SRC_URI="https://dev.gentoo.org/~mgorny/dist/${P}.tar.bz2"
	KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~amd64-fbsd ~sparc-fbsd ~x86-fbsd ~ppc-aix ~x64-freebsd ~x86-freebsd ~hppa-hpux ~ia64-hpux ~x86-interix ~amd64-linux ~ia64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~m68k-mint ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
fi

DESCRIPTION="Eselect module for management of multiple Python versions"
HOMEPAGE="https://www.gentoo.org/proj/en/Python/"

LICENSE="GPL-2"
SLOT="0"
IUSE=""

RDEPEND=">=app-admin/eselect-1.2.3
	>=dev-lang/python-exec-2.1:2
	!<dev-lang/python-2.7.10-r4:2.7
	!<dev-lang/python-3.3.5-r4:3.3
	!<dev-lang/python-3.4.3-r4:3.4
	!<dev-lang/python-3.5.0-r3:3.5"

src_prepare() {
	[[ ${PV} == "99999999" ]] && eautoreconf
}

src_install() {
	keepdir /etc/env.d/python
	emake DESTDIR="${D}" install || die

	local f
	for f in python{,2,3}; do
		# can't use symlinks here since random stuff
		# loves to do readlink on sys.executable...
		newbin "${EPREFIX}/usr/lib/python-exec/python-exec2" "${f}"
	done
	for f in python{,2,3}-config 2to3 idle pydoc pyvenv; do
		dosym ../lib/python-exec/python-exec2 /usr/bin/"${f}"
	done
}

pkg_preinst() {
	local py

	# Copy python[23] selection from the old format (symlink)
	for py in 2 3; do
		# default to none
		declare -g "PREV_PYTHON${py}"=

		if [[ -L ${EROOT}/usr/bin/python${py} ]]; then
			local target=$(readlink "${EROOT}/usr/bin/python${py}")

			# check if it's actually old eselect symlink
			if [[ ${target} == python?.? ]]; then
				declare -g "PREV_PYTHON${py}=${target}"
			fi
		fi
	done
}

pkg_postinst() {
	local py

	if has_version 'dev-lang/python'; then
		eselect python update --if-unset
	fi

	for py in 2 3; do
		local pyvar=PREV_PYTHON${py}
		if [[ -n ${!pyvar} ]]; then
			einfo "Setting Python${py} to ${!pyvar}"
			eselect python set "--python${py}" "${!pyvar}"
		elif has_version "=dev-lang/python-${py}*"; then
			eselect python update "--python${py}" --if-unset
		fi
	done
}
