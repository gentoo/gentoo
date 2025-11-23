# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

DESCRIPTION="mtink is a status monitor and inkjet cartridge changer for some Epson printers"
HOMEPAGE="https://web.archive.org/web/20160316185818/http://xwtools.automatix.de/"
SRC_URI="https://web.archive.org/web/20160316185818/http://xwtools.automatix.de/files/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~ppc ~sparc x86"
IUSE="cups doc X"

DEPEND="
	virtual/libusb:0
	cups? ( net-print/cups )
	X? (
		x11-libs/libX11
		x11-libs/libXpm
		x11-libs/libXt
		x11-libs/motif:0
	)
	cups? ( net-print/cups )
	virtual/libusb:0"
RDEPEND="${DEPEND}"

PATCHES=(
	"${FILESDIR}"/${P}-overflow.patch
	"${FILESDIR}"/${P}-flags.patch
	"${FILESDIR}"/${P}-motif.patch
	"${FILESDIR}"/${P}-fno-common.patch
	"${FILESDIR}"/${P}-fix-function-declarations.patch
)

src_prepare() {
	default
	sed -i -e "s/gcc/$(tc-getCC)/g" Makefile.ORG || die
}

src_configure() {
	if use X ; then
		./Configure || die
	else
		./Configure -x || die
	fi
}

src_compile() {
	local mytargets
	mytargets="ttink detect/askPrinter mtinkd"

	if use X; then
		mytargets="${mytargets} mtink mtinkc";
	fi

	export CFLAGS LDFLAGS
	emake ${mytargets}
}

src_install() {
	dobin ttink detect/askPrinter

	use X && dobin mtinkc mtink

	dosbin mtinkd

	newinitd "${FILESDIR}"/mtinkd.rc mtinkd
	newconfd "${FILESDIR}"/mtinkd.confd mtinkd

	if use cups; then
		exeinto /usr/lib/cups/backend
		doexe etc/mtink-cups
	fi

	dodoc html/README CHANGE.LOG
	use doc && dodoc -r html/*.{gif,html}
}

pkg_postinst() {
	# see #70310
	chmod 700 /var/mtink /var/run/mtink 2>/dev/null

	elog
	elog "mtink needs correct permissions to access printer device."
	elog "To do this you either need to run the following chmod command:"
	elog "chmod 666 /dev/<device>"
	elog "or set the suid bit on mtink, mtinkc and ttink in /usr/bin"
	elog
}
