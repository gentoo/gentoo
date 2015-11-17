# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

if [[ ${PV} == "99999999" ]] ; then
	inherit autotools git-r3
	EGIT_REPO_URI="git://anongit.gentoo.org/proj/${PN}.git"
	EGIT_BRANCH="mgornys-hackery"
else
	SRC_URI="mirror://gentoo/${P}.tar.bz2
		https://dev.gentoo.org/~floppym/dist/${P}.tar.bz2"
	KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~amd64-fbsd ~sparc-fbsd ~x86-fbsd ~ppc-aix ~x64-freebsd ~x86-freebsd ~hppa-hpux ~ia64-hpux ~x86-interix ~amd64-linux ~ia64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~m68k-mint ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
fi

DESCRIPTION="Eselect module for management of multiple Python versions"
HOMEPAGE="https://www.gentoo.org/proj/en/Python/"

LICENSE="GPL-2"
SLOT="0"
IUSE=""

# TODO: add appropriate >= dep on python-exec
RDEPEND=">=app-admin/eselect-1.2.3
	dev-lang/python-exec:2
	!<dev-lang/python-2.7.10-r3:2.7
	!<dev-lang/python-3.3.5-r3:3.3
	!<dev-lang/python-3.4.3-r3:3.4
	!<dev-lang/python-3.5.0-r2:3.5"

src_prepare() {
	[[ ${PV} == "99999999" ]] && eautoreconf
}

src_install() {
	keepdir /etc/env.d/python
	emake DESTDIR="${D}" install || die

	local f
	for f in python{,2,3}{,-config} 2to3 pydoc pyvenv; do
		dosym ../lib/python-exec/python-exec2 /usr/bin/"${f}"
	done
}

pkg_postinst() {
	if has_version 'dev-lang/python'; then
		eselect python update --if-unset
	fi
	if has_version '=dev-lang/python-2*'; then
		eselect python update --python2 --if-unset
	fi
	if has_version '=dev-lang/python-3*'; then
		eselect python update --python3 --if-unset
	fi
}
