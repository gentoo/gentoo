# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="create dependencies in makefiles using 'gcc -M'"
HOMEPAGE="https://www.x.org/wiki/ https://cgit.freedesktop.org/"

if [[ ${PV} == 9999 ]]; then
	EGIT_REPO_URI="https://anongit.freedesktop.org/git/xorg/util/${PN}.git"
	inherit autotools git-r3
	# x11-misc/util-macros only required on live ebuilds
	LIVE_DEPEND=">=x11-misc/util-macros-1.18"
else
	SRC_URI="mirror://xorg/util/${P}.tar.bz2"
	KEYWORDS="~alpha amd64 ~arm ~arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~amd64-fbsd ~x86-fbsd ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos ~sparc-solaris ~x64-solaris ~x86-solaris"
fi

LICENSE="MIT"
SLOT="0"
IUSE=""

DEPEND="
	${LIVE_DEPEND}
	x11-base/xorg-proto
"

src_prepare() {
	default
	[[ ${PV} == 9999 ]] && eautoreconf
}

src_configure() {
	local econfargs=(
		--disable-selective-werror
	)

	econf "${econfargs[@]}"
}
