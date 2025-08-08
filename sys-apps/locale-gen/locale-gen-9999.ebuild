# Copyright 2023-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Generate locales based upon the config file /etc/locale.gen"
HOMEPAGE="https://gitweb.gentoo.org/proj/locale-gen.git/"

if [[ ${PV} == 9999 ]] ; then
	EGIT_REPO_URI="https://anongit.gentoo.org/git/proj/locale-gen.git"
	inherit git-r3
else
	SRC_URI="https://gitweb.gentoo.org/proj/locale-gen.git/snapshot/${P}.tar.bz2"

	#KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~loong ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86"
fi

LICENSE="GPL-2"
SLOT="0"

RDEPEND="
	dev-lang/perl
	!<sys-libs/glibc-2.37-r3
"

src_install() {
	dosbin locale-gen
	doman *.[0-8]
	insinto /etc
	doins locale.gen
	keepdir /usr/lib/locale
}
