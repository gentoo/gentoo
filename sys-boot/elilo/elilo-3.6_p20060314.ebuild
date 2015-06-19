# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-boot/elilo/elilo-3.6_p20060314.ebuild,v 1.4 2011/04/02 12:00:12 armin76 Exp $

inherit toolchain-funcs eutils

DESCRIPTION="Linux boot loader for EFI-based systems such as IA-64"
HOMEPAGE="http://elilo.sourceforge.net/"
if [[ $PV == *_p* ]] ; then
	MY_P=${PV#*_p}
	MY_P=${PN}-nightly_${MY_P:0:4}-${MY_P:4:2}-${MY_P:6:2}
	SRC_URI="http://elilo.sourceforge.net/nightlies/${MY_P}.tgz"
	S=${WORKDIR}/elilo
else
	MY_P=${P}
	SRC_URI="mirror://sourceforge/elilo/${P}.src.tgz"
fi
SRC_URI="${SRC_URI} mirror://debian/pool/main/e/elilo/elilo_3.6-1.diff.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="ia64"
IUSE=""

# gnu-efi contains only static libs, so there's no run-time dep on it
DEPEND=">=sys-boot/gnu-efi-3.0
	sys-devel/patch
	dev-util/patchutils"
RDEPEND="sys-boot/efibootmgr
	sys-fs/dosfstools"

S=${WORKDIR}/${PN}

src_unpack() {
	unpack ${A}
	cd "${S}"

	ebegin Applying ../*.diff
	# Using epatch on this is annoying because it wants to create the elilo-3.6/
	# directory.  Since all the files are new, it doesn't know better.
	filterdiff -p1 -i debian/\* ../*.diff | patch -s -p1
	eend $? || return

	# Add patch for vmm support, from
	# http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=350185
	epatch "${FILESDIR}"/elilo.sh-vmm.patch

	# Don't count files twice when summing bytesneeded
	epatch "${FILESDIR}"/elilo.sh-chkspace.patch

	# Now Gentooize it
	sed -i "
		1s/sh/bash/;
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
