# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-boot/elilo/elilo-3.10.ebuild,v 1.3 2011/04/02 12:00:12 armin76 Exp $

inherit toolchain-funcs eutils

DESCRIPTION="Linux boot loader for EFI-based systems such as IA-64"
HOMEPAGE="http://elilo.sourceforge.net/"
SRC_URI="mirror://sourceforge/elilo/${P}.tar.gz"
SRC_URI="${SRC_URI} mirror://debian/pool/main/e/elilo/elilo_3.10-1.diff.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ia64 ~x86"
IUSE=""

# gnu-efi contains only static libs, so there's no run-time dep on it
DEPEND=">=sys-boot/gnu-efi-3.0g
	sys-devel/patch
	dev-util/patchutils"
RDEPEND="sys-boot/efibootmgr
	sys-fs/dosfstools"

src_unpack() {
	unpack ${A}
	cd "${S}"

	ebegin Applying ../*.diff
	# Using epatch on this is annoying because it wants to create the elilo-3.6/
	# directory.  Since all the files are new, it doesn't know better.
	filterdiff -p1 -i debian/\* ../*.diff | patch -s -p1
	eend $? || return

	# Now Gentooize it
	sed -i "
		1s:/bin/sh:/bin/bash:;
		s/##VERSION##/$PV/;
		s/Debian GNU\//Gentoo /g;
		s/Debian/Gentoo/g;
		s/debian/gentoo/g;
		s/dpkg --print-installation-architecture/uname -m/" debian/elilo.sh
}

src_compile() {
	local iarch
	case $(tc-arch) in
		ia64) iarch=ia64 ;;
		x86)  iarch=ia32 ;;
		amd64) iarch=x86_64 ;;
		*)    die "unknown architecture: $(tc-arch)" ;;
	esac

	# "prefix" on the next line specifies where to find gcc, as, ld,
	# etc.  It's not the usual meaning of "prefix".  By blanking it we
	# allow PATH to be searched.
	emake -j1 prefix= CC="$(tc-getCC)" ARCH=${iarch} || die "emake failed"
}

src_install() {
	exeinto /usr/lib/elilo
	doexe elilo.efi || die "elilo.efi failed"

	newsbin debian/elilo.sh elilo || die "elilo failed"
	dosbin tools/eliloalt || die "eliloalt failed"

	insinto /etc
	newins "${FILESDIR}"/elilo.conf.sample elilo.conf

	dodoc docs/* "${FILESDIR}"/elilo.conf.sample
	doman debian/*.[0-9]
}
