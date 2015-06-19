# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-electronics/ghdl/ghdl-0.29.ebuild,v 1.4 2013/08/04 09:10:43 tomjbe Exp $

EAPI="3"

inherit eutils multilib

GCC_VERSION="4.3.4"
GNATGCC_SLOT="4.3"

DESCRIPTION="Complete VHDL simulator using the GCC technology"
HOMEPAGE="http://ghdl.free.fr"
SRC_URI="http://ghdl.free.fr/${P}.tar.bz2
	mirror://gnu/gcc/releases/gcc-${GCC_VERSION}/gcc-core-${GCC_VERSION}.tar.bz2"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE=""
DEPEND="<sys-apps/texinfo-5.1
	dev-lang/gnat-gcc:${GNATGCC_SLOT}"
RDEPEND=""
S="${WORKDIR}/gcc-${GCC_VERSION}"

ADA_INCLUDE_PATH="${ROOT}/usr/lib/gnat-gcc/${CHOST}/${GNATGCC_SLOT}/adainclude"
ADA_OBJECTS_PATH="${ROOT}/usr/lib/gnat-gcc/${CHOST}/${GNATGCC_SLOT}/adalib"
GNATGCC_PATH="${ROOT}/usr/${CHOST}/gnat-gcc-bin/${GNATGCC_SLOT}:${ROOT}/usr/libexec/gnat-gcc/${CHOST}/${GNATGCC_SLOT}"

src_prepare() {
	mv "${WORKDIR}/${P}"/vhdl gcc
	sed -i -e 's/ADAC = \$(CC)/ADAC = gnatgcc/' gcc/vhdl/Makefile.in || die "sed failed"
	sed -i \
		-e 's/AGCC_CFLAGS=-g/AGCC_CFLAGS=$(CFLAGS)/' \
		-e 's/rm -rf $(infodir)/rm -rf $(DESTDIR)$(infodir)/' \
		gcc/vhdl/Make-lang.in || die "sed failed"

	# Fix issue similar to bug #195074, ported from vapier's fix for binutils
	sed -i -e "s:egrep.*texinfo.*dev/null:egrep 'texinfo[^0-9]*(4\.([4-9]|[1-9][0-9])|[5-9]|[1-9][0-9])' >/dev/null:" \
		configure* || die "sed failed"

	# For multilib profile arch, see bug #203721
	if (has_multilib_profile || use multilib ) ; then
		for T_LINUX64 in `find "${S}/gcc/config" -name t-linux64` ;
		do
			einfo "sed for ${T_LINUX64} for multilib. :)"
			sed -i \
				-e "s:\(MULTILIB_OSDIRNAMES = \).*:\1../lib64 ../lib32:" \
				"${T_LINUX64}" \
			|| die "sed for ${T_LINUX64} failed. :("
		done
	fi

	# fix for bug #477552 backported from bug #424970
	epatch "${FILESDIR}"/${P}-gcc.patch
}

src_configure() {
	PATH="${GNATGCC_PATH}:${PATH}" econf --enable-languages=vhdl
}

src_compile() {
	PATH="${GNATGCC_PATH}:${PATH}" emake -j1 || die "Compilation failed"
}

src_install() {
	# bug #277644
	PATH="${GNATGCC_PATH}:${PATH}" emake -j1 DESTDIR="${D}" install || die "Installation failed"

	cd "${D}"/usr/bin ; rm `ls --ignore=ghdl`
	rm -rf "${D}"/usr/include
	rm "${D}"/usr/$(get_libdir)/lib*
	cd "${D}"/usr/$(get_libdir)/gcc/${CHOST}/${GCC_VERSION} ; rm -rf `ls --ignore=vhdl*`
	cd "${D}"/usr/libexec/gcc/${CHOST}/${GCC_VERSION} ; rm -rf `ls --ignore=ghdl*`
	cd "${D}"/usr/share/info ; rm `ls --ignore=ghdl*`
	cd "${D}"/usr/share/man/man1 ; rm `ls --ignore=ghdl*`
	rm -Rf "${D}"/usr/share/locale
	rm -Rf "${D}"/usr/share/man/man7
}
