# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

inherit mount-boot flag-o-matic toolchain-funcs eutils

DEB_PL="1"
MY_PV="${PV##*_p}"
MY_GIT="git${MY_PV%%_*}"
MY_PV="${PV%%_*}"
MY_P="${PN}_${MY_PV}+${MY_GIT}"

DESCRIPTION="SPARC/UltraSPARC Improved Loader, a boot loader for sparc"
SRC_URI="mirror://debian/pool/main/s/${PN}/${MY_P}.orig.tar.gz
	mirror://debian/pool/main/s/${PN}/${MY_P}-${DEB_PL}.diff.gz"
HOMEPAGE="https://git.kernel.org/?p=linux/kernel/git/davem/silo.git;a=summary"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="-* sparc"
IUSE="hardened"

DEPEND="sys-fs/e2fsprogs
	sys-apps/sparc-utils"
RDEPEND=""

ABI_ALLOW="sparc32"

S="${WORKDIR}/${PN}"

src_unpack() {
	unpack ${A}
	cd "${S}"

	#Set the correct version
	sed -i -e "s/1.4.14/1.4.14_git20120226_p1/g" Rules.make

	# Fix build failure
	sed -i -e "s/-fno-strict-aliasing/-fno-strict-aliasing -U_FORTIFY_SOURCE -mcpu=v9/g" Rules.make
}

src_compile() {
	filter-flags "-fstack-protector"

	if use hardened
	then
		make ${MAKEOPTS} CC="$(tc-getCC) -fno-stack-protector -fno-pic"
	else
		make ${MAKEOPTS} CC="$(tc-getCC)" || die
	fi
}

src_install() {
	make DESTDIR="${D}" install || die
	dodoc first-isofs/README.SILO_ISOFS docs/README*

	# Fix maketilo manpage
	rm "${D}"/usr/share/man/man1/maketilo.1
	dosym /usr/share/man/man1/tilo.1 /usr/share/man/man1/maketilo.1
}

pkg_postinst() {
	mount-boot_pkg_postinst
	ewarn "NOTE: If this is an upgrade to an existing SILO install,"
	ewarn "      you will need to re-run silo as the /boot/second.b"
	ewarn "      file has changed, else the system will fail to load"
	ewarn "      SILO at the next boot."
	ewarn
	ewarn "Support for EXT4 is broken, you've been warned!!"
}
