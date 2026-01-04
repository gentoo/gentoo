# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit flag-o-matic toolchain-funcs

DESCRIPTION="Simple Network Time Protocol (NTP) client"
HOMEPAGE="https://cr.yp.to/clockspeed.html"

# this is the trailing part of the name for the latest leapseconds file.
LEAPSECONDS_DATE="20081114"

SRC_URI="https://cr.yp.to/clockspeed/${P}.tar.gz
	https://dev.gentoo.org/~pacho/maintainer-needed/leapsecs.dat."$LEAPSECONDS_DATE""

# http://cr.yp.to/distributors.html
LICENSE="public-domain"
SLOT="0"
KEYWORDS="amd64 ~mips x86"
IUSE="static selinux"
RESTRICT="test"

DEPEND="sys-apps/groff"
RDEPEND="net-dns/djbdns"

PATCHES=(
	"${FILESDIR}"/${P}-gentoo.patch
	"${FILESDIR}"/${P}-fix-build-for-clang21-gcc15.patch
)

src_configure() {
	append-cflags -std=gnu17 # XXX https://bugs.gentoo.org/946519, workaround for gcc15

	echo "$(tc-getCC) ${CFLAGS} ${ASFLAGS}" > conf-cc || die
	use static && append-ldflags -static
	echo "$(tc-getCC) ${LDFLAGS}" > conf-ld || die
	sed -i \
		-e "s:^echo 'ar cr :echo '$(tc-getAR) cr :g" \
		-e "s:^  echo 'ranlib :  echo '$(tc-getRANLIB) :g" \
		make-makelib.sh || die
}

src_install() {
	dobin clockspeed clockadd clockview sntpclock taiclock taiclockd
	dosbin "${FILESDIR}"/ntpclockset

	doman *.1
	dodoc BLURB CHANGES INSTALL README THANKS TODO

	insinto /var/lib/clockspeed
	newins "${DISTDIR}"/leapsecs.dat."$LEAPSECONDS_DATE" leapsecs.dat
}
