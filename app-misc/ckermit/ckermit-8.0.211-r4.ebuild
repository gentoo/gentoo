# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-misc/ckermit/ckermit-8.0.211-r4.ebuild,v 1.6 2015/08/03 20:51:09 sping Exp $

EAPI="4"

inherit versionator eutils flag-o-matic toolchain-funcs

# Columbia University only uses the third component, e.g. cku211.tar.gz for
# what we would call 8.0.211.
MY_P="cku$( get_version_component_range 3 ${PV} )"

DESCRIPTION="combined serial and network communication software package"
SRC_URI="ftp://kermit.columbia.edu/kermit/archives/${MY_P}.tar.gz"
HOMEPAGE="http://www.kermitproject.org/"

LICENSE="Kermit"
SLOT="0"
KEYWORDS="amd64 arm ~hppa ppc ppc64 x86"
IUSE="ncurses"

DEPEND="ncurses? ( >=sys-libs/ncurses-5.2 )"
RDEPEND="${DEPEND}
	net-dialup/lrzsz"

S=${WORKDIR}

src_prepare() {
	epatch "${FILESDIR}"/${P}-cleanup.patch
	epatch "${FILESDIR}"/${P}-build-wart.patch
	tc-export_build_env BUILD_CC
	sed -i -r \
		-e 's:"(CC2?) = gcc":"\1=$(CC)":g' \
		-e 's:"CFLAGS = -O:"CFLAGS = $(CFLAGS):' \
		makefile || die
}

ck_use() {
	use $1 && append-cppflags $2 && libs+=" $3"
}
src_compile() {
	# we don't enable any of the telnet/ftp authentication stuff
	# since there are other packages which do these things better
	# USE="kerberos pam shadow ssl zlib"
	append-cppflags -DNO_AUTHENTICATION -DNOLOGIN -DNOFTP

	local libs
	ck_use ncurses -DCK_NCURSES -lncurses
	append-cppflags -DHAVE_PTMX -D_XOPEN_SOURCE -D_BSD_SOURCE #202840
	append-cppflags -DHAVE_CRYPT_H
	emake \
		CC="$(tc-getCC)" \
		KFLAGS="${CPPFLAGS}" \
		LIBS="-lcrypt -lresolv ${libs}" \
		LNKFLAGS="${LDFLAGS}" \
		linuxa
}

src_install() {
	dodir /usr/bin /usr/share/man/man1
	emake \
		DESTDIR="${ED}" \
		BINDIR=/usr/bin \
		MANDIR="${ED}"/usr/share/man/man1 \
		MANEXT=1 \
		install
	dodoc *.txt

	# make the correct symlink
	rm "${ED}"/usr/bin/kermit-sshsub || die
	dosym /usr/bin/kermit /usr/bin/kermit-sshsub

	# the ckermit.ini script is calling the wrong kermit binary --
	# the one from ${D}
	sed -i "s:${D}::g" "${ED}"/usr/bin/ckermit.ini
}
