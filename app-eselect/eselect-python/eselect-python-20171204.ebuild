# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

if [[ ${PV} == "99999999" ]] ; then
	inherit autotools git-r3
	EGIT_REPO_URI="git://anongit.gentoo.org/proj/${PN}.git"
else
	SRC_URI="https://dev.gentoo.org/~mgorny/dist/${P}.tar.bz2"
	KEYWORDS="alpha amd64 arm arm64 hppa ia64 m68k ~mips ppc ppc64 s390 sh sparc x86 ~ppc-aix ~x64-cygwin ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~m68k-mint ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
fi

DESCRIPTION="Eselect module for management of multiple Python versions"
HOMEPAGE="https://wiki.gentoo.org/wiki/Project:Python"

LICENSE="GPL-2"
SLOT="0"
IUSE=""

# python-exec-2.4.2 for working -l option
RDEPEND=">=app-admin/eselect-1.2.3
	>=dev-lang/python-exec-2.4.2"

src_prepare() {
	default
	[[ ${PV} == "99999999" ]] && eautoreconf
}

pkg_postinst() {
	local py

	if has_version 'dev-lang/python'; then
		eselect python update --if-unset
	fi

	if has_version "=dev-lang/python-3*"; then
		eselect python update "--python3" --if-unset
	fi
}
