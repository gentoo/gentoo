# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs

DESCRIPTION="dockapp that monitors one or more mailboxes"
HOMEPAGE="http://tnemeth.free.fr/projets/dockapps.html"
SRC_URI="http://tnemeth.free.fr/projets/programmes/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~ppc64 ~sparc ~x86"

RDEPEND="x11-libs/gtk+:2
	x11-libs/libXpm"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

PATCHES=(
	"${FILESDIR}"/${PN}-2.2.1-checkthread.patch
	"${FILESDIR}"/${P}-fno-common.patch
	"${FILESDIR}"/${P}-ssl.patch
)

src_configure() {
	# The ./configure script is not autoconf based, therefore don't use econf:
	./configure -p /usr || die
}

src_compile() {
	emake \
		CC="$(tc-getCC)" \
		CPP="$(tc-getCPP)" \
		CFLAGS="${CFLAGS}" \
		DEBUG_LDFLAGS="" \
		LDFLAGS="${LDFLAGS}" \
		DEBUG_CFLAGS=""
}

src_install() {
	dobin ${PN}/${PN} ${PN}-config/${PN}-config
	doman doc/*.1
	dodoc AUTHORS ChangeLog FAQ NEWS README THANKS TODO doc/sample.${PN}rc
}
