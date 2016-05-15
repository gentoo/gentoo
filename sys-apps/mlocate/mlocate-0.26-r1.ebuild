# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4
inherit eutils user toolchain-funcs

DESCRIPTION="Merging locate is an utility to index and quickly search for files"
HOMEPAGE="https://fedorahosted.org/mlocate/"
SRC_URI="https://fedorahosted.org/releases/m/l/mlocate/${P}.tar.xz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 arm ~arm64 hppa ia64 m68k ~mips ppc ppc64 s390 sh sparc x86"
IUSE="nls selinux"

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
	doins "${FILESDIR}"/mlocate-cron.conf
	fperms 0644 /etc/{updatedb,mlocate-cron}.conf

	insinto /etc/cron.daily
	newins "${FILESDIR}"/mlocate.cron-r2 mlocate
	fperms 0755 /etc/cron.daily/mlocate

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
}
