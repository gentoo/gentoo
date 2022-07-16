# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# Instructions to make a dist tarball:
# git clone https://github.com/mgorny/eclass-to-manpage && cd eclass-to-manpage
# make dist ECLASSDIR=~/g/eclass/

DESCRIPTION="Collection of Gentoo eclass manpages"
HOMEPAGE="https://github.com/mgorny/eclass-to-manpage"
if [[ ${PV} == *9999* ]] ; then
	EGIT_REPO_URI="https://anongit.gentoo.org/git/repo/gentoo.git
		https://github.com/gentoo/gentoo.git"
	inherit git-r3

	MY_ECLASSDIR="eclass"
else
	SRC_URI="https://dev.gentoo.org/~sam/distfiles/${CATEGORY}/${PN}/${P}.tar.xz"

	# Keep the keywords stable. No need to change to ~arch.
	KEYWORDS="~alpha amd64 arm arm64 ~hppa ~ia64 ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86 ~amd64-linux ~x86-linux ~x64-macos ~x86-solaris"

	MY_ECLASSDIR="."
fi

LICENSE="GPL-2"
SLOT="0"

BDEPEND="sys-apps/gawk
	sys-apps/groff"

src_unpack() {
	if [[ ${PV} == *9999* ]] ; then
		git-r3_fetch
		git-r3_fetch "https://github.com/mgorny/eclass-to-manpage"

		git-r3_checkout '' '' '' eclass
		git-r3_checkout "https://github.com/mgorny/eclass-to-manpage"
	else
		default
	fi
}

src_compile() {
	emake ECLASSDIR=${MY_ECLASSDIR}
}

src_install() {
	emake install ECLASSDIR=${MY_ECLASSDIR} DESTDIR="${D}" PREFIX="${EPREFIX}/usr"
}
