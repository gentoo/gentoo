# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-fs/atari-fdisk/atari-fdisk-0.7.1.5.4.ebuild,v 1.2 2013/02/12 08:19:50 armin76 Exp $

inherit versionator toolchain-funcs

MY_PV=$(get_version_component_range 1-3)
DEB_PV=$(get_version_component_range 4-5)
DESCRIPTION="create and edit the partition table of a disk partitioned in Atari format"
HOMEPAGE="http://packages.qa.debian.org/a/atari-fdisk.html"
SRC_URI="mirror://debian/pool/main/a/${PN}/${PN}_${MY_PV}-${DEB_PV}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 m68k ~mips ~ppc ~s390 ~sh ~sparc ~x86"
IUSE=""

DEPEND=""

S=${WORKDIR}/${PN}-${MY_PV}

src_compile() {
	emake \
		CFLAGS="${CFLAGS}" \
		LDFLAGS="${LDFLAGS}" \
		COMPILE_ARCH=m68k \
		|| die
}

src_install() {
	dodoc NEWS README TODO debian/changelog
	doman debian/atari-fdisk.8

	into /
	if [[ $(tc-arch) == "m68k" ]] ; then
		dosbin fdisk || die "sbin fdisk failed"
		dosym fdisk /sbin/atari-fdisk
		dosym atari-fdisk.8 /usr/share/man/man8/fdisk.8
	else
		dosbin atari-fdisk || die "sbin atari-fdisk failed"
	fi
}
