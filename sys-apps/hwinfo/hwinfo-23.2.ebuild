# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs

DESCRIPTION="Hardware detection tool used in SuSE Linux"
HOMEPAGE="https://github.com/openSUSE/hwinfo/"
SRC_URI="https://github.com/openSUSE/hwinfo/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc ~riscv ~x86 ~amd64-linux ~x86-linux"

RDEPEND="amd64? ( dev-libs/libx86emu )
	x86? ( dev-libs/libx86emu )"
DEPEND="${RDEPEND}
	>=sys-kernel/linux-headers-2.6.17"
BDEPEND="sys-devel/flex"

src_prepare() {
	default
	# Respect AR variable.
	sed -i \
		-e 's:ar r:$(AR) r:' \
		src/{,isdn,ids,smp,hd}/Makefile || die

	# Respect LDFLAGS.
	sed -i -e 's:$(CC) $(CFLAGS):$(CC) $(LDFLAGS) $(CFLAGS):' src/ids/Makefile || die

	# Respect MAKE variable. Skip forced -pipe and -g.
	sed -i \
		-e 's:make:$(MAKE):' \
		-e 's:-pipe -g::' \
		Makefile{,.common} || die
	rm -f git2log || die
}

src_compile() {
	emake -j1 AR="$(tc-getAR)" CC="$(tc-getCC)" HWINFO_VERSION="${PV}" \
		RPM_OPT_FLAGS="${CFLAGS}" LIBDIR="${EPREFIX}/usr/$(get_libdir)"
}

src_install() {
	emake DESTDIR="${ED}" LIBDIR="/usr/$(get_libdir)" install
	keepdir /var/lib/hardware/udi

	dodoc README*
	docinto examples
	dodoc doc/example*.c
	doman doc/*.{1,8}
}
