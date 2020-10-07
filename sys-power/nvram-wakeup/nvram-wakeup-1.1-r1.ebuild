# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit flag-o-matic

MY_P=${P/e}
DESCRIPTION="read and write the WakeUp time in the BIOS"
HOMEPAGE="https://sourceforge.net/projects/nvram-wakeup"
SRC_URI="mirror://sourceforge/nvram-wakeup/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

S=${WORKDIR}/${MY_P}

src_prepare() {
	default
	# Need to be careful with CFLAGS since this could eat your bios
	strip-flags
	# GTTXT mode fix
	sed -i \
		-e '/^CFLAGS/s:= -O2 :+= $(CPPFLAGS) :' \
		-e '/GTTXT/s:755:644:' \
		Makefile || die
	# do not compress manpages
	sed -i -e 's:\(\$(MAN[58]\)GZ):\1):' Makefile || die
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
	ewarn "This program writes into the NVRAM (used by BIOS to store the CMOS"
	ewarn "settings).  This is DANGEROUS.  This can brick your whole computer."
	ewarn "Use at your own risk."
}
