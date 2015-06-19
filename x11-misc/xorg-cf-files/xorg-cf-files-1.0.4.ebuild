# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-misc/xorg-cf-files/xorg-cf-files-1.0.4.ebuild,v 1.10 2013/02/21 18:47:07 zmedico Exp $

EAPI=3

inherit xorg-2

DESCRIPTION="Old Imake-related build files"
KEYWORDS="alpha amd64 arm hppa ia64 ~mips ppc ppc64 s390 sh sparc x86 ~amd64-fbsd ~x86-fbsd ~x86-interix ~amd64-linux ~arm-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~x64-solaris ~x86-solaris"
IUSE=""

RDEPEND=""
DEPEND="${RDEPEND}"

PATCHES=(
	"${FILESDIR}"/${PN}-1.0.2-solaris-prefix.patch
)

src_install() {
	xorg-2_src_install
	echo "#define ManDirectoryRoot ${EPREFIX}/usr/share/man" >> ${ED}/usr/$(get_libdir)/X11/config/host.def
	sed -i -e "s/LibDirName *lib$/LibDirName $(get_libdir)/" "${ED}"/usr/$(get_libdir)/X11/config/Imake.tmpl || die "failed libdir sed"
	sed -i -e "s|LibDir Concat(ProjectRoot,/lib/X11)|LibDir Concat(ProjectRoot,/$(get_libdir)/X11)|" ${ED}/usr/$(get_libdir)/X11/config/X11.tmpl || die "failed libdir sed"
	sed -i -e "s|\(EtcX11Directory \)\(/etc/X11$\)|\1${EPREFIX}\2|" ${ED}/usr/$(get_libdir)/X11/config/X11.tmpl || die "failed etcx11dir sed"
	sed -i -e "/#  define Solaris64bitSubdir/d" ${ED}/usr/$(get_libdir)/X11/config/sun.cf
	sed -i -e 's/-DNOSTDHDRS//g' ${ED}/usr/$(get_libdir)/X11/config/sun.cf
}
