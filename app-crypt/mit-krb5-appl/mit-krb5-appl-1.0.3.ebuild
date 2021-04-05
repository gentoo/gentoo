# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools flag-o-matic toolchain-funcs

MY_P=${P/mit-}
MAJOR_MINOR="$(ver_cut 1-2)"
DESCRIPTION="Kerberized applications split from the main MIT Kerberos V distribution"
HOMEPAGE="http://web.mit.edu/kerberos/www/"
SRC_URI="http://web.mit.edu/kerberos/dist/krb5-appl/${MAJOR_MINOR}/${MY_P}-signed.tar"
S="${WORKDIR}/${MY_P}"

LICENSE="openafs-krb5-a BSD"
SLOT="0"
KEYWORDS="~alpha amd64 arm ~hppa ~ia64 ~m68k ~mips ppc ppc64 ~s390 sparc x86"

BDEPEND="virtual/pkgconfig"
RDEPEND=">=app-crypt/mit-krb5-1.8.0
	sys-libs/e2fsprogs-libs
	sys-libs/ncurses"
DEPEND="${RDEPEND}"

PATCHES=(
	"${FILESDIR}/${PN}-tinfo.patch"
	"${FILESDIR}/${PN}-sig_t.patch"
)

src_unpack() {
	unpack ${A}
	unpack ./"${MY_P}".tar.gz
}

src_prepare() {
	default

	sed -i -e "s/-lncurses/$($(tc-getPKG_CONFIG) --libs ncurses)/" configure.ac || die
	eautoreconf
}

src_configure() {
	append-cppflags "-I/usr/include/et"
	append-cppflags -fno-strict-aliasing
	append-cppflags -fno-strict-overflow
	econf
}

src_install() {
	emake DESTDIR="${ED}" install
	for i in {telnetd,ftpd} ; do
		mv "${ED}"/usr/share/man/man8/${i}.8 "${ED}"/usr/share/man/man8/k${i}.8 \
			|| die "mv failed (man)"
		mv "${ED}"/usr/sbin/${i} "${ED}"/usr/sbin/k${i} || die "mv failed"
	done

	for i in {rcp,rlogin,rsh,telnet,ftp} ; do
		mv "${ED}"/usr/share/man/man1/${i}.1 "${ED}"/usr/share/man/man1/k${i}.1 \
			|| die "mv failed (man)"
		mv "${ED}"/usr/bin/${i} "${ED}"/usr/bin/k${i} || die "mv failed"
	done

	rm "${ED}"/usr/share/man/man1/tmac.doc || die
	dodoc README
}
