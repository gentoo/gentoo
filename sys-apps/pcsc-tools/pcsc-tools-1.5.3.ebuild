# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit desktop toolchain-funcs xdg-utils

DESCRIPTION="PC/SC Architecture smartcard tools"
HOMEPAGE="http://ludovic.rousseau.free.fr/softwares/pcsc-tools/"
SRC_URI="http://ludovic.rousseau.free.fr/softwares/${PN}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~arm ~hppa ppc ppc64 x86"
IUSE="gtk network-cron"

DEPEND=">=sys-apps/pcsc-lite-1.4.14"
RDEPEND="${DEPEND}
	dev-perl/pcsc-perl
	gtk? ( dev-perl/Gtk2 )"
BDEPEND="virtual/pkgconfig"

DOCS=(
	README Changelog
)

src_compile() {
	# explicitly only build the pcsc_scan application, or the man
	# pages will be gzipped first, and then unpacked.
	emake pcsc_scan CC=$(tc-getCC)
}

src_install() {
	einstalldocs

	# install manually, makes it much easier since the Makefile
	# requires fiddling with
	dobin ATR_analysis scriptor pcsc_scan
	doman pcsc_scan.1 scriptor.1p ATR_analysis.1p

	if use gtk; then
		domenu gscriptor.desktop
		dobin gscriptor
		doman gscriptor.1p
	fi

	if use network-cron ; then
		exeinto /etc/cron.monthly
		newexe "${FILESDIR}"/smartcard.cron update-smartcard_list
	fi

	insinto /usr/share/pcsc
	doins smartcard_list.txt
}

pkg_postinst() {
	use gtk && xdg_desktop_database_update
}

pkg_postrm() {
	xdg_desktop_database_update
}
