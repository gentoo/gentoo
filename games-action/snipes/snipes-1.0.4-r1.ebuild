# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit desktop flag-o-matic toolchain-funcs

DESCRIPTION="2D scrolling shooter, resembles the old DOS game of same name"
HOMEPAGE="https://wiki.gentoo.org/wiki/No_homepage"
SRC_URI="mirror://gentoo/${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="media-libs/libsdl[sound,video]"
DEPEND="${RDEPEND}"

PATCHES=(
	"${FILESDIR}"/${P}-ldflags.patch
)

src_compile() {
	tc-export CC LD

	# lld requires arch flags to be passed even if native (bug #730852)
	local archflags=
	tc-ld-is-lld && eval archflags=\${LDFLAGS_${ARCH}}

	LDLIBS=-lm emake RAW_LDFLAGS="${archflags} $(raw-ldflags)"
}

src_install() {
	dobin snipes
	doman snipes.6
	einstalldocs

	doicon ${PN}.png
	make_desktop_entry ${PN} ${PN^}
}
