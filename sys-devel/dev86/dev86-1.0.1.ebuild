# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
inherit toolchain-funcs

DESCRIPTION="Bruce's C compiler - Simple C compiler to generate 8086 code"
HOMEPAGE="http://www.debath.co.uk/ https://github.com/lkundrak/dev86"
SRC_URI="https://codeberg.org/jbruchon/dev86/archive/v${PV}.tar.gz -> Dev86src-${PV}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc ~ppc64 ~x86"
IUSE=""

RDEPEND="sys-devel/bin86"
DEPEND="${RDEPEND}"

PATCHES=(
	"${FILESDIR}/${P}-makefile.patch"
)

S="${WORKDIR}/dev86"

src_prepare() {
	default

	sed -i -e "s|-O2 -g|${CFLAGS}|" -e '/INEXE=/s:-s::' makefile.in || die
	sed -i -e "s:/lib/:/$(get_libdir)/:" bcc/bcc.c || die
	sed -i -e '/INSTALL_OPTS=/s:-s::' bin86/Makefile || die
	sed -i -e '/install -m 755 -s/s:-s::' dis88/Makefile || die
}

src_compile() {
	# Don't mess with CPPFLAGS as they tend to break compilation
	# (bug #343655).
	unset CPPFLAGS

	ln -s lib lib64 || die
	ln -s ../kinclude/arch libc/include/arch || die
	ln -s ../kinclude/linuxmt libc/include/linuxmt || die

	# First `make` is also a config, so set all the path vars here
	emake -j1 \
		CC="$(tc-getCC)" \
		LIBDIR="/usr/$(get_libdir)/bcc" \
		INCLDIR="/usr/$(get_libdir)/bcc" \
		all

	export PATH=${S}/bin:${PATH}

	cd bootblocks || die
	emake \
		HOSTCC="$(tc-getCC)"

}

src_install() {
	emake -j1 install-all DIST="${D}"
	dostrip -x "/usr/*/bcc/lib*.a /usr/*/i386/libc.a"

	dobin bootblocks/makeboot
	# remove all the stuff supplied by bin86
	rm "${D}"/usr/bin/{as,ld,nm,objdump,size}86 || die
	rm "${D}"/usr/man/man1/{as,ld}86.1 || die

	dodir /usr/share
	mv "${D}"/usr/{man,share/man} || die
}
