# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=9

if [[ ${PV} = 99999999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/gentoo/gentoo.git"
	S="${WORKDIR}/${P}/eclass"
else
	# Instructions to make a dist tarball:
	# cd /path/to/gentoo-repo
	# tar -cJf ${P}.tar.xz --transform="s:^eclass/:${P}/:" eclass/*.eclass
	SRC_URI="https://distfiles.gentoo.org/pub/proj/qa/${PN}/${P}.tar.xz"
	# Keep the keywords stable. No need to change to ~arch.
	KEYWORDS="~alpha amd64 arm arm64 ~hppa ~m68k ~mips ppc ppc64 ~riscv ~s390 ~sparc x86 ~x64-macos"
fi

DESCRIPTION="Collection of Gentoo eclass manpages"
HOMEPAGE="https://gitweb.gentoo.org/repo/gentoo.git/tree/eclass"

LICENSE="GPL-2"
SLOT="0"

BDEPEND="sys-apps/pkgcore"

if [[ ${PV} = 99999999 ]]; then
	src_unpack() {
		git-r3_fetch
		git-r3_checkout "" "" "" eclass
	}
fi

src_compile() {
	pmaint eclass -f man -o "{eclass}.eclass.5" *.eclass
}

src_install() {
	doman *.5
}
