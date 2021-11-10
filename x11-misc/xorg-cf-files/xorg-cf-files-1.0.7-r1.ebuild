# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Old Imake-related build files"
HOMEPAGE="https://www.x.org/wiki/ https://gitlab.freedesktop.org/xorg/util/cf"
SRC_URI="https://www.x.org/releases/individual/util/${P}.tar.bz2
	https://dev.gentoo.org/~mattst88/distfiles/${PN}-1.0.6-solaris-prefix.patch.bz2"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm ~arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~riscv ~s390 sparc ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~sparc-solaris ~x64-solaris ~x86-solaris"

BDEPEND="
	virtual/pkgconfig
	app-arch/bzip2
"

PATCHES=(
	"${WORKDIR}"/${PN}-1.0.6-solaris-prefix.patch
	"${FILESDIR}"/${PN}-1.0.7-linux-riscv.patch
)

src_install() {
	default
	echo "#define ManDirectoryRoot ${EPREFIX}/usr/share/man" >> \
		"${ED}"/usr/$(get_libdir)/X11/config/host.def || die
	sed -i -e "s|LibDirName *lib$|LibDirName $(get_libdir)|" \
		"${ED}"/usr/$(get_libdir)/X11/config/Imake.tmpl || die "failed libdir sed"
	sed -i -e "s|LibDir Concat(ProjectRoot,/lib/X11)|LibDir Concat(ProjectRoot,/$(get_libdir)/X11)|" \
		"${ED}"/usr/$(get_libdir)/X11/config/X11.tmpl || die "failed libdir sed"
	sed -i -e "s|\(EtcX11Directory \)\(/etc/X11$\)|\1${EPREFIX}\2|" \
		"${ED}"/usr/$(get_libdir)/X11/config/X11.tmpl || die "failed etcx11dir sed"
	sed -i -e "/#  define Solaris64bitSubdir/d" \
		"${ED}"/usr/$(get_libdir)/X11/config/sun.cf || die
	sed -i -e 's/-DNOSTDHDRS//g' \
		"${ED}"/usr/$(get_libdir)/X11/config/sun.cf || die

	sed -r -i -e "s|LibDirName[[:space:]]+lib.*$|LibDirName $(get_libdir)|" \
		"${ED}"/usr/$(get_libdir)/X11/config/linux.cf || die "failed libdir sed"
	sed -r -i -e "s|SystemUsrLibDir[[:space:]]+/usr/lib.*$|SystemUsrLibDir /usr/$(get_libdir)|" \
		"${ED}"/usr/$(get_libdir)/X11/config/linux.cf || die "failed libdir sed"
	sed -r -i -e "s|TkLibDir[[:space:]]+/usr/lib.*$|TkLibDir /usr/$(get_libdir)|" \
		"${ED}"/usr/$(get_libdir)/X11/config/linux.cf || die "failed libdir sed"
}
