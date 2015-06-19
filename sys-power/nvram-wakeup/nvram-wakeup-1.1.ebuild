# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-power/nvram-wakeup/nvram-wakeup-1.1.ebuild,v 1.1 2013/01/06 22:48:26 vapier Exp $

EAPI="4"

inherit flag-o-matic eutils

MY_P=${P%_p*}
[[ ${PV} == *_p* ]] && REV=${P#*_p} || unset REV
MY_P=${MY_P/e}
DESCRIPTION="read and write the WakeUp time in the BIOS"
HOMEPAGE="http://sourceforge.net/projects/nvram-wakeup"
SRC_URI="mirror://sourceforge/nvram-wakeup/${MY_P}.tar.gz
	${REV+http://nvram-wakeup.svn.sourceforge.net/viewvc/*checkout*/nvram-wakeup/trunk/nvram-wakeup/nvram-wakeup-mb.c?revision=${REV}}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="nls"
[[ -n ${REV} ]] && RESTRICT="mirror" #168114

DEPEND="nls? ( sys-devel/gettext )"
RDEPEND=""

S=${WORKDIR}/${MY_P}

src_unpack() {
	unpack ${MY_P}.tar.gz
	if [[ -n ${REV} ]] ; then
		cp "${DISTDIR}"/nvram-wakeup-mb.c?revision=${REV} "${S}"/nvram-wakeup-mb.c || die
	fi
}

src_prepare() {
	use nls || epatch "${FILESDIR}"/${PN}-0.97-nonls.patch
	# Need to be careful with CFLAGS since this could eat your bios
	strip-flags
	# GTTXT mode fix: https://sourceforge.net/tracker/?func=detail&aid=3599718&group_id=35022&atid=412757
	sed -i \
		-e '/^CFLAGS/s:= -O2 :+= $(CPPFLAGS) :' \
		-e '/GTTXT/s:755:644:' \
		Makefile || die
}

src_install() {
	emake \
		prefix="${D}"/usr \
		MANDIR="${D}"/usr/share/man \
		DOCDIR="${D}"/usr/share/doc/${PF} \
		install

	dodoc "${D}"/usr/bin/vdrshutdown
	rm "${D}"/usr/bin/vdrshutdown || die
	dodoc set_timer

	rm "${D}"/usr/sbin/time || die
	rm "${D}"/usr/share/man/man*/time.8* || die
}

pkg_postinst() {
	echo
	ewarn "WARNING:"
	ewarn "This program  writes into the  NVRAM  (used by  BIOS to store the CMOS"
	ewarn "settings).  This is  DANGEROUS.  Do it at  your own  risk.  Neither the"
	ewarn "author  of  this program  (nvram-wakeup)  nor anyone else  can be made"
	ewarn "responsible to any damage made by this program in any way."
	ewarn "(The worst case  happened to me is that on reboot the BIOS noticed the"
	ewarn "illegal  contents of  the nvram and  set everything to default values."
	ewarn "But this doesn't mean that you can't destroy even your whole computer.)"
	echo
	ewarn "		YOU HAVE BEEN WARNED, HAVE A NICE DAY"
	echo
}
