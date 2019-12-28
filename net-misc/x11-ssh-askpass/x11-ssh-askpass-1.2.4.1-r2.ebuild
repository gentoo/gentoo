# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

DESCRIPTION="X11-based passphrase dialog for use with OpenSSH"
HOMEPAGE="http://www.liquidmeme.net/software/x11-ssh-askpass
	https://github.com/sigmavirus24/x11-ssh-askpass"
SRC_URI="http://www.liquidmeme.net/software/x11-ssh-askpass/${P}.tar.gz"

LICENSE="HPND"
SLOT="0"
KEYWORDS="alpha amd64 ia64 ppc ~ppc64 sparc x86"
IUSE=""

RDEPEND="virtual/ssh
	x11-libs/libXt
	x11-libs/libX11
	x11-libs/libSM
	x11-libs/libICE"
DEPEND="${RDEPEND}"
BDEPEND="x11-misc/imake
	app-text/rman"

src_configure() {
	econf --libexecdir=/usr/$(get_libdir)/misc \
		--disable-installing-app-defaults
	xmkmf || die "xmkmf failed"
}

src_compile() {
	emake includes
	emake CC="$(tc-getCC)" CDEBUGFLAGS="${CFLAGS}"
}

src_install() {
	default
	newman x11-ssh-askpass.man x11-ssh-askpass.1
	dosym ../"$(get_libdir)"/misc/x11-ssh-askpass /usr/bin/x11-ssh-askpass
}
