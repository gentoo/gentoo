# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="A serialmail is a collection of tools for passing mail across serial links"
HOMEPAGE="http://cr.yp.to/serialmail.html"
SRC_URI="http://cr.yp.to/software/${P}.tar.gz
	mirror://gentoo/${P}-patch.tar.bz2"

LICENSE="all-rights-reserved"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="static"
RESTRICT="mirror bindist"

BDEPEND="sys-apps/groff"
DEPEND=">=sys-apps/ucspi-tcp-0.88"
RDEPEND="
	${DEPEND}
	virtual/daemontools
"

PATCHES=(
	"${WORKDIR}"/${P}-gentoo.patch
	"${WORKDIR}"/${P}-smtpauth.patch
	"${WORKDIR}"/${P}-smtpauth_comp.patch
	"${FILESDIR}"/${P}-implicit.patch
)

src_prepare() {
	default

	sed -i "s|@CFLAGS@|${CFLAGS}|" conf-cc || die
	use static && LDFLAGS="${LDFLAGS} -static"
	sed -i "s|@LDFLAGS@|${LDFLAGS}|" conf-ld || die
}

src_compile() {
	sed -i -e '/(man|doc)/d' hier.c || die
	emake it man
}

src_install() {
	dobin serialsmtp serialqmtp maildirsmtp maildirserial maildirqmtp

	dodoc AUTOTURN CHANGES FROMISP SYSDEPS THANKS TOISP \
		BLURB FILES INSTALL README TARGETS TODO VERSION

	doman maildirqmtp.1 maildirserial.1 maildirsmtp.1 \
		serialqmtp.1 serialsmtp.1
}
