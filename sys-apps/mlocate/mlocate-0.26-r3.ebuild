# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit eutils user toolchain-funcs systemd

DESCRIPTION="Merging locate is an utility to index and quickly search for files"
HOMEPAGE="https://pagure.io/mlocate"
SRC_URI="http://releases.pagure.org/mlocate/${P}.tar.xz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 arm ~arm64 hppa ia64 ~m68k ~mips ppc ppc64 ~s390 ~sh sparc x86"
IUSE="+cron nls selinux systemd"

RDEPEND="!sys-apps/slocate
	!sys-apps/rlocate
	selinux? ( sec-policy/selinux-slocate )"
DEPEND="app-arch/xz-utils
	nls? ( sys-devel/gettext )
"

pkg_setup() {
	enewgroup locate
}

src_configure() {
	econf $(use_enable nls)
}

src_compile() {
	emake groupname=locate AR="$(tc-getAR)"
}

src_install() {
	emake groupname=locate DESTDIR="${D}" install
	dodoc AUTHORS ChangeLog README NEWS

	insinto /etc
	doins "${FILESDIR}"/updatedb.conf
	fperms 0644 /etc/updatedb.conf

	if use cron; then
		insinto /etc
		doins "${FILESDIR}"/mlocate-cron.conf
		fperms 0644 /etc/mlocate-cron.conf

		insinto /etc/cron.daily
		newins "${FILESDIR}"/mlocate.cron-r3 mlocate
		fperms 0755 /etc/cron.daily/mlocate
	fi

	if use systemd; then
		insinto "`systemd_get_systemunitdir`"
		doins "${FILESDIR}"/updatedb.service
		doins "${FILESDIR}"/updatedb.timer
	fi

	fowners 0:locate /usr/bin/locate
	fperms go-r,g+s /usr/bin/locate

	keepdir /var/lib/mlocate
	chown -R 0:locate "${ED}"/var/lib/mlocate
	fperms 0750 /var/lib/mlocate
}

pkg_postinst() {
	elog "The database for the locate command is generated daily by a cron job,"
	elog "if you install for the first time you can run the updatedb command manually now."
	elog
	elog "Note that the /etc/updatedb.conf file is generic,"
	elog "please customize it to your system requirements."

	if use systemd; then
		elog
		elog "The systemd timer updatedb.timer has been installed,"
		elog "please activate it with 'systemd enable updatedb.timer'"
	fi
}
