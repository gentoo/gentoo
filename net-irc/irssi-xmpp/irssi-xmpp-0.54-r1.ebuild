# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs

DESCRIPTION="Irssi plugin providing Jabber/XMPP support"
HOMEPAGE="https://github.com/cdidier/irssi-xmpp"
SRC_URI="https://github.com/cdidier/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
SRC_URI+=" https://dev.gentoo.org/~sam/distfiles/${CATEGORY}/${PN}/${P}-musl-build.patch"
SRC_URI+=" https://dev.gentoo.org/~sam/distfiles/${CATEGORY}/${PN}/${P}-irssi.patch.xz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

BDEPEND="virtual/pkgconfig"
DEPEND="
	net-irc/irssi
	net-libs/loudmouth
"
RDEPEND="${DEPEND}"

PATCHES=(
	"${DISTDIR}"/${P}-musl-build.patch
	"${WORKDIR}"/${P}-irssi.patch
)

src_prepare() {
	default

	sed -e "s/{MAKE} doc-install/{MAKE}/" \
		-i Makefile || die #322355
}

src_compile() {
	emake PREFIX=/usr CC="$(tc-getCC)"
}

src_install() {
	emake DESTDIR="${ED}" PREFIX=/usr IRSSI_LIB=/usr/$(get_libdir)/irssi install
	dodoc README.md NEWS TODO docs/*
}
