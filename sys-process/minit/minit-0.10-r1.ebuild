# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit toolchain-funcs

DESCRIPTION="a small yet feature-complete init"
HOMEPAGE="http://www.fefe.de/minit/"
SRC_URI="http://dl.fefe.de/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"

DEPEND="
	dev-libs/libowfat
	dev-libs/dietlibc"

RDEPEND="${DEPEND}"

PATCHES=(
	"${FILESDIR}"/minit-0.10-fixes.diff
)

DOCS=( CHANGES README TODO )

src_compile() {
	emake CFLAGS="${CFLAGS} -I/usr/include/libowfat" \
		LDFLAGS="${LDFLAGS}" \
		DIET="diet"\
		CC="$(tc-getCC)"
}

src_install() {
	emake install-files DESTDIR="${D}"
	mv "${D}"/sbin/shutdown "${D}/sbin/${PN}-shutdown" || die
	mv "${D}"/sbin/killall5 "${D}/sbin/${PN}-killall5" || die
	rm -v "${D}"/sbin/init || die
}

pkg_postinst() {
	[[ -e /etc/minit/in ]] || mkfifo "${ROOT}"/etc/minit/in
	[[ -e /etc/minit/out ]] || mkfifo "${ROOT}"/etc/minit/out
}
