# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit multilib rpm toolchain-funcs

DESCRIPTION="Hardware detection tool used in SuSE Linux"
HOMEPAGE="https://www.opensuse.org/"
SRC_URI="http://download.opensuse.org/tumbleweed/repo/src-oss/src/${P}-1.3.src.rpm"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~ppc ~x86 ~amd64-linux ~x86-linux"
IUSE=""

RDEPEND="
	amd64? ( dev-libs/libx86emu )
	x86? ( dev-libs/libx86emu )"
DEPEND="${RDEPEND}
	sys-devel/flex
	>=sys-kernel/linux-headers-2.6.17"

MAKEOPTS="${MAKEOPTS} -j1"

src_prepare() {
	# Respect AR variable.
	sed -i \
		-e 's:ar r:$(AR) r:' \
		src/{,isdn,ids,smp,hd}/Makefile || die

	# Respect LDFLAGS.
	sed -i -e 's:$(CC) $(CFLAGS):$(CC) $(LDFLAGS) $(CFLAGS):' src/ids/Makefile || die

	# Respect MAKE variable. Skip forced -pipe and -g. Respect LDFLAGS.
	sed -i \
		-e 's:make:$(MAKE):' \
		-e 's:-pipe -g::' \
		-e 's:LDFLAGS.*=:LDFLAGS +=:' \
		Makefile{,.common} || die
	# Workaround from Arch, for using raw tarballs from git
	echo 'touch changelog' > git2log
	default
}

src_compile() {
	tc-export AR
	emake CC="$(tc-getCC)" RPM_OPT_FLAGS="${CFLAGS}"
}

src_install() {
	emake DESTDIR="${ED}" LIBDIR="/usr/$(get_libdir)" install
	keepdir /var/lib/hardware/udi

	dodoc changelog README*
	docinto examples
	dodoc doc/example*.c
	doman doc/*.{1,8}
}
