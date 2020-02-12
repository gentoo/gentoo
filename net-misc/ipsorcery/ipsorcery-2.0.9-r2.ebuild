# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit flag-o-matic toolchain-funcs

DESCRIPTION="Ipsorcery allows you to generate IP, TCP, UDP, ICMP, and IGMP packets"
HOMEPAGE="https://wiki.gentoo.org/wiki/No_homepage"
SRC_URI="mirror://gentoo/ipsorc-${PV}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc ~sparc x86"
IUSE="gtk"

DEPEND="
	gtk? (
		dev-libs/glib:2=
		x11-libs/gtk+:2=
	)
"
RDEPEND="
	${DEPEND}
"
S=${WORKDIR}/ipsorc-${PV}
PATCHES=(
	"${FILESDIR}"/${P}-_BSD_SOURCE.patch
	"${FILESDIR}"/${P}-gentoo.patch
)

src_compile() {
	append-cflags -fcommon
	emake \
		CC="$(tc-getCC)" \
		PKG_CONFIG=$(tc-getPKG_CONFIG) \
		con $(usex gtk gtk '')
}

src_install() {
	dosbin ipmagic $(usex gtk magic '')
	dodoc BUGS changelog HOWTO README
}
