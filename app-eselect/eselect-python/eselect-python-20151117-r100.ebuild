# Copyright 1999-2016 Gentoo Foundation
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
	>=dev-lang/python-exec-2.2-r100"

src_prepare() {
	[[ ${PV} == "99999999" ]] && eautoreconf
}

src_install() {
	keepdir /etc/env.d/python
	emake DESTDIR="${D}" install
}

pkg_postinst() {
	local py

	if has_version 'dev-lang/python'; then
		eselect python update --if-unset
	fi

	for py in 2 3; do
		if has_version "=dev-lang/python-${py}*"; then
			eselect python update "--python${py}" --if-unset
		fi
	done
}
