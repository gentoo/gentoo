# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs

DESCRIPTION="Bruce's C compiler - Simple C compiler to generate 8086 code"
HOMEPAGE="https://www.debath.co.uk/ https://github.com/lkundrak/dev86"
SRC_URI="http://v3.sk/~lkundrak/dev86/Dev86src-${PV}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc ~ppc64 ~x86"

RDEPEND="sys-devel/bin86"
DEPEND="
	${RDEPEND}
	dev-util/gperf
"

PATCHES=(
	"${FILESDIR}"/${PN}-pic.patch
	"${FILESDIR}"/${PN}-0.16.19-fortify.patch
	"${FILESDIR}"/${P}-non-void-return-clang.patch
	"${FILESDIR}"/${P}-make.patch
	"${FILESDIR}"/${P}-void-return-check-msdos-clang-fix.patch
	"${FILESDIR}"/${P}-dbprintf-missing-includes-fix.patch
	"${FILESDIR}"/${P}_gcc14-fixes.patch
)

src_prepare() {
	default

	# elksemu doesn't compile under amd64
	if use amd64; then
		einfo "Not compiling elksemu on amd64"
		sed -i \
			-e 's,alt-libs elksemu,alt-libs,' \
			-e 's,install-lib install-emu,install-lib,' \
			makefile.in || die
	fi

	sed -i -e "s|-O2 -g|${CFLAGS}|" -e '/INEXE=/s:-s::' makefile.in || die
	sed -i -e "s:/lib/:/$(get_libdir)/:" bcc/bcc.c || die
	sed -i -e '/INSTALL_OPTS=/s:-s::' bin86/Makefile || die
	sed -i -e '/install -m 755 -s/s:-s::' dis88/Makefile || die
}

src_compile() {
	# Don't mess with CPPFLAGS as they tend to break compilation
	# (bug #343655).
	unset CPPFLAGS

	# First `make` is also a config, so set all the path vars here
	emake -j1 \
		CC="$(tc-getCC)" \
		LIBDIR="/usr/$(get_libdir)/bcc" \
		INCLDIR="/usr/$(get_libdir)/bcc" \
		all

	export PATH=${S}/bin:${PATH}

	pushd bin > /dev/null || die
	ln -s ncc bcc || die
	popd > /dev/null || die

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
