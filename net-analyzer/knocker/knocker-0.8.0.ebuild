# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

DESCRIPTION="Knocker is an easy to use security port scanner written in C"
HOMEPAGE="https://knocker.sourceforge.net"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"

PATCHES=(
	"${FILESDIR}"/${PN}-0.8.0-fency.patch
	"${FILESDIR}"/${PN}-0.7.1-knocker_user_is_root.patch
)

DOCS=( AUTHORS BUGS ChangeLog NEWS README TO-DO )

src_configure() {
	tc-export CC
	default
}
