# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4
inherit multilib rpm toolchain-funcs

DESCRIPTION="hardware detection tool used in SuSE Linux"
HOMEPAGE="http://www.opensuse.org/"
SRC_URI="http://download.opensuse.org/source/factory/repo/oss/suse/src/${P}-1.2.src.rpm"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc x86 ~amd64-linux ~x86-linux"
IUSE=""

RDEPEND="amd64? ( dev-libs/libx86emu )
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

	# Avoid -I directories for dbus because HAL is obsolete.
	sed -i -e '/CFLAGS/d' src/hd/Makefile || die
	# Respect LDFLAGS.
	sed -i -e 's:$(CC) -shared:& $(LDFLAGS):' src/Makefile || die
	sed -i -e 's:$(CC) $(CFLAGS):$(CC) $(LDFLAGS) $(CFLAGS):' src/ids/Makefile || die

	# Respect MAKE variable. Skip forced -pipe and -g. Respect LDFLAGS.
	sed -i \
		-e 's:make:$(MAKE):' \
		-e 's:-pipe -g::' \
		-e 's:LDFLAGS.*=:LDFLAGS +=:' \
		Makefile{,.common} || die
}

src_compile() {
	tc-export AR
	emake CC="$(tc-getCC)" RPM_OPT_FLAGS="${CFLAGS}"
}

src_install() {
	emake DESTDIR="${ED}" LIBDIR="/usr/$(get_libdir)" install

	dodoc changelog README
	doman doc/hwinfo.8
	insinto /usr/share/doc/${PF}/examples
	doins doc/example*.c
}
