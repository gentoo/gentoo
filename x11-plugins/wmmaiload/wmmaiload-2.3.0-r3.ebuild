# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
inherit meson

DESCRIPTION="dockapp that monitors one or more mailboxes"
HOMEPAGE="http://tnemeth.free.fr/projets/dockapps.html"
SRC_URI="http://tnemeth.free.fr/projets/programmes/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~ppc64 ~sparc ~x86"

RDEPEND="x11-libs/gtk+:2
	x11-libs/libXpm
	dev-libs/openssl"

DEPEND="${RDEPEND}
	virtual/pkgconfig"
PATCHES=(
	"${FILESDIR}"/${PN}-2.2.1-checkthread.patch
	"${FILESDIR}"/${P}-fno-common.patch
	"${FILESDIR}"/${P}-ssl.patch
	"${FILESDIR}"/${P}-c23.patch
)

src_prepare() {
	default

	cp "${FILESDIR}"/meson.build . || die "No new build file"
	rm -f wmmaiload/config.h && touch wmmaiload/config.h || die "Can't remove stale config"
	rm -f wmmaiload-config/config.h && touch wmmaiload-config/config.h || die "Can't remove stale config"
}

src_install() {
	meson_install

	doman doc/*.1
	dodoc AUTHORS ChangeLog FAQ NEWS README THANKS TODO doc/sample.${PN}rc
}
