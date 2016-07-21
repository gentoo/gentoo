# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

inherit xorg-2

DESCRIPTION="Old Imake-related build files"
KEYWORDS="alpha amd64 arm ~arm64 hppa ia64 ~mips ppc ppc64 ~s390 ~sh sparc x86 ~amd64-fbsd ~x86-fbsd ~x86-interix ~amd64-linux ~arm-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~x64-solaris ~x86-solaris"
IUSE=""

RDEPEND=""
DEPEND="${RDEPEND}"

PATCHES=(
	"${FILESDIR}"/${PN}-1.0.2-solaris-prefix.patch
)

src_install() {
	xorg-2_src_install
	echo "#define ManDirectoryRoot ${EPREFIX}/usr/share/man" >> "${ED}"/usr/$(get_libdir)/X11/config/host.def
	sed -i -e "s/LibDirName *lib$/LibDirName $(get_libdir)/" "${ED}"/usr/$(get_libdir)/X11/config/Imake.tmpl || die "failed libdir sed"
	sed -i -e "s|LibDir Concat(ProjectRoot,/lib/X11)|LibDir Concat(ProjectRoot,/$(get_libdir)/X11)|" "${ED}"/usr/$(get_libdir)/X11/config/X11.tmpl || die "failed libdir sed"
	sed -i -e "s|\(EtcX11Directory \)\(/etc/X11$\)|\1${EPREFIX}\2|" "${ED}"/usr/$(get_libdir)/X11/config/X11.tmpl || die "failed etcx11dir sed"
	sed -i -e "/#  define Solaris64bitSubdir/d" "${ED}"/usr/$(get_libdir)/X11/config/sun.cf
	sed -i -e 's/-DNOSTDHDRS//g' "${ED}"/usr/$(get_libdir)/X11/config/sun.cf

	sed -r -i -e "s|LibDirName[[:space:]]+lib.*$|LibDirName $(get_libdir)|" "${ED}"/usr/$(get_libdir)/X11/config/linux.cf || die "failed libdir sed"
	sed -r -i -e "s|SystemUsrLibDir[[:space:]]+/usr/lib.*$|SystemUsrLibDir /usr/$(get_libdir)|" "${ED}"/usr/$(get_libdir)/X11/config/linux.cf || die "failed libdir sed"
	sed -r -i -e "s|TkLibDir[[:space:]]+/usr/lib.*$|TkLibDir /usr/$(get_libdir)|" "${ED}"/usr/$(get_libdir)/X11/config/linux.cf || die "failed libdir sed"
}
