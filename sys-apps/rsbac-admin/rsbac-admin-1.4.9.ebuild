# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit multilib toolchain-funcs

DESCRIPTION="Rule Set Based Access Control (RSBAC) Admin Tools"
HOMEPAGE="http://www.rsbac.org/"
SRC_URI="http://download.rsbac.org/code/${PV}/${P}.tar.xz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
# using rklogd is deprecated but offer the option since it is fully removed
# from source
IUSE="pam rklogd"

DEPEND="
	dev-util/dialog
	pam? ( sys-libs/pam )
	sys-apps/baselayout
	>=sys-libs/ncurses-5.2"

RDEPEND="${DEPEND}"

src_compile() {
	local rsbacmakeargs="libs tools"
	use rklogd && rsbacmakeargs="${rsbacmakeargs} rklogd"
	use pam && rsbacmakeargs="${rsbacmakeargs} pam nss"
	emake PREFIX=/usr LIBDIR=/$(get_libdir) ${rsbacmakeargs}
}

src_install() {
	local rsbacinstallargs="headers-install libs-install tools-install"
	use rklogd && rsbacinstallargs="${rsbacinstallargs} rklogd-install"
	use pam && rsbacinstallargs="${rsbacinstallargs} pam-install nss-install"
	emake PREFIX=/usr LIBDIR=/$(get_libdir) DESTDIR="${D}" ${rsbacinstallargs}

	use rklogd && doinitd "${FILESDIR}"/rklogd

	insinto /etc
	doins "${FILESDIR}"/rsbac.conf

	#FHS compliance
	dodir /usr/$(get_libdir)
	mv "${D}"/$(get_libdir)/librsbac.{,l}a "${D}"/usr/$(get_libdir)
	mv "${D}"/$(get_libdir)/libnss_rsbac.{,l}a "${D}"/usr/$(get_libdir)
	gen_usr_ldscript librsbac.so
	gen_usr_ldscript libnss_rsbac.so
}

pkg_postinst() {
	einfo "********************************************************************************"
	einfo "You have to add a security user to your system if you have not already done so."
	einfo "The name could be 'secoff' or 'security' and, if you did not change the default"
	einfo "uid in the RSBAC kernel configuration, then the following will work:"
	einfo
	einfo "    groupadd -g 400 security"
	einfo "    useradd -g 400 -u 400 security"
	einfo
	einfo "We suggest you run a separate copy of syslog-ng (for example) to log RSBAC"
	einfo "messages as user 'audit' (uid 404) instead of using the deprecated rklogd."
	einfo "See"
	einfo
	einfo "    http://www.rsbac.org/documentation/administration_examples/syslog-ng"
	einfo
	einfo "for more information."
	einfo "********************************************************************************"
}
