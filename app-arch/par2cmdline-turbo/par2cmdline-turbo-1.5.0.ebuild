# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools flag-o-matic

if [[ ${PV} == 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/animetosho/par2cmdline-turbo"
else
	SRC_URI="https://github.com/animetosho/${PN}/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~arm ~arm64 ~ppc ~ppc64 ~x86"
fi

DESCRIPTION="par2cmdline × ParPar: speed focused par2cmdline fork"
HOMEPAGE="https://github.com/animetosho/par2cmdline-turbo"

LICENSE="GPL-2+"
SLOT="0"

RDEPEND="
	!app-arch/par2cmdline
"

PATCHES=("${FILESDIR}/${PN}-no-inline-hints.patch")

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	# Needed for -Og to be buildable, otherwise fails a/ always_inline (bug #961901))
	is-flagq '-Og' && append-cppflags -DPAR2_NO_INLINE_HINTS

	econf
}
