# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-apps/rsbac-admin/rsbac-admin-1.4.6.ebuild,v 1.1 2012/01/07 20:14:04 blueness Exp $

EAPI="4"

inherit user multilib toolchain-funcs

DESCRIPTION="Rule Set Based Access Control (RSBAC) Admin Tools"
HOMEPAGE="http://www.rsbac.org/"
SRC_URI="http://www.rsbac.org/dl.php?file=code/${PV}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="pam"

DEPEND="
	dev-util/dialog
	pam? ( sys-libs/pam )
	sys-apps/baselayout"

RDEPEND="
	${DEPEND}
	>=sys-libs/ncurses-5.2"

src_compile() {
	local rsbacmakeargs="libs tools"
	use pam && rsbacmakeargs="${makeargs} pam nss"
	emake PREFIX=/usr LIBDIR=/$(get_libdir) ${rsbacmakeargs}
}

src_install() {
	local rsbacinstallargs="headers-install libs-install tools-install"
	use pam && rsbacinstallargs="${rsbacinstallargs} pam-install nss-install"
	emake PREFIX=/usr LIBDIR=/$(get_libdir) DESTDIR="${D}" ${rsbacinstallargs}

	insinto /etc
	doins "${FILESDIR}"/rsbac.conf
	doins "${FILESDIR}"/nsswitch.conf

	dodir /secoff
	keepdir /secoff

	dodir /var/log/rsbac
	keepdir /var/log/rsbac

	#FHS compliance
	dodir /usr/$(get_libdir)
	mv "${D}"/$(get_libdir)/librsbac.{,l}a "${D}"/usr/$(get_libdir)
	mv "${D}"/$(get_libdir)/libnss_rsbac.{,l}a "${D}"/usr/$(get_libdir)
	gen_usr_ldscript librsbac.so
	gen_usr_ldscript libnss_rsbac.so
}

pkg_postinst() {
	enewgroup secoff 400
	enewuser secoff 400 /bin/bash /secoff secoff
	enewgroup audit 404
	enewuser audit 404 -1 /dev/null audit

	chmod 700 /secoff /var/log/rsbac
	chown secoff:secoff -R /secoff

	einfo "It is suggested to run (for example) a separate copy of syslog-ng to"
	einfo "log RSBAC messages, as user audit (uid 404) instead of using the deprecated"
	einfo "rklogd. See http://www.rsbac.org/documentation/administration_examples/syslog-ng"
	einfo "for more information."
}
