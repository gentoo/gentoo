# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit toolchain-funcs

MY_P="${PN}_${PV}"
DESCRIPTION="Interconverts between various bibliography formats using common XML intermediate"
HOMEPAGE="https://sourceforge.net/p/bibutils/home/Bibutils/"
SRC_URI="mirror://sourceforge/${PN}/${MY_P}_src.tgz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~ppc ~x86"
IUSE=""

S=${WORKDIR}/${MY_P}

src_configure() {
	# The custom configure script still sucks several releases later, so we'll
	# just do its job ourselves
	rm -f Makefile configure || die "Failed to purge old Makefile"
	sed \
		-e "s:REPLACE_CC:$(tc-getCC):g" \
		-e "s:REPLACE_EXEEXT::g" \
		-e "s:REPLACE_LIBTARGET:libbibutils.so:g" \
		-e "s:REPLACE_LIBEXT:.so:g" \
		-e "s:REPLACE_CFLAGS:${CFLAGS}:g" \
		-e "s:REPLACE_CLIBFLAGS:${CFLAGS} -fPIC:g" \
		-e "s:REPLACE_RANLIB:$(tc-getRANLIB):g" \
		-e 's:REPLACE_POSTFIX::g' \
		-e "s:REPLACE_INSTALLDIR:\"${D}/usr/bin\":g" \
		-e "s:REPLACE_LIBINSTALLDIR:\"${D}/usr/$(get_libdir)\":g" \
		-e 's:make:$(MAKE):g' \
		Makefile_start > Makefile \
		|| die "Failed to set up Makefile"

	cp lib/Makefile.dynamic  lib/Makefile || die
	cp bin/Makefile.dynamic  bin/Makefile || die
	cp test/Makefile.dynamic test/Makefile || die
}

src_install() {
	dodir /usr/bin
	emake install
	dodoc ChangeLog
}
