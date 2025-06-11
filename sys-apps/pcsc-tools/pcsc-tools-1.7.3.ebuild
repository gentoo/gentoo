# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit meson xdg-utils

DESCRIPTION="PC/SC Architecture smartcard tools"
HOMEPAGE="https://pcsc-tools.apdu.fr/ https://github.com/LudovicRousseau/pcsc-tools"
SRC_URI="https://pcsc-tools.apdu.fr/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~arm ~arm64 ~hppa ppc ppc64 x86"
IUSE="gui network-cron"

DEPEND=">=sys-apps/pcsc-lite-1.4.14"
RDEPEND="
	${DEPEND}
	dev-perl/libintl-perl
	dev-perl/pcsc-perl
	gui? ( dev-perl/Gtk3 )
"

src_install() {
	meson_src_install

	# USE=gui controls gscriptor for bug #323229
	if ! use gui ; then
		rm "${ED}"/usr/bin/gscriptor || die
		rm "${ED}"/usr/share/pcsc/gscriptor.png || die
		rm "${ED}"/usr/share/applications/gscriptor.desktop || die
		rm "${ED}"/usr/share/man/man1/gscriptor.1 || die
	fi

	if use network-cron ; then
		exeinto /etc/cron.monthly
		newexe "${FILESDIR}"/smartcard.cron update-smartcard_list
	fi
}

pkg_postinst() {
	use gui && xdg_desktop_database_update
}

pkg_postrm() {
	# No USE=gui conditional here, as we may have just disabled it
	xdg_desktop_database_update
}
