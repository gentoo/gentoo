# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
inherit toolchain-funcs

DESCRIPTION="Text to Morse Code converter"
HOMEPAGE="http://cwtext.sourceforge.net"
SRC_URI="https://downloads.sourceforge.net/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~mips ppc ppc64 x86"

PATCHES=(
	"${FILESDIR}"/${PN}-0.96-pcm.patch
	"${FILESDIR}"/${PN}-0.94-asneeded.patch
	"${FILESDIR}"/${PN}-0.96-fix-missing-include.patch
)

DOCS=( Changes README TODO )

src_prepare() {
	eapply -p0 "${PATCHES[@]}"
	# change install directory to ${S}
	sed -i -e "/^PREFIX/ s:=.*:=\"${S}\":" makefile || \
		die "sed makefile failed"

	eapply_user
	tc-export CC
}

src_install() {
	einstalldocs
	dobin cwtext cwpcm cwmm
}
