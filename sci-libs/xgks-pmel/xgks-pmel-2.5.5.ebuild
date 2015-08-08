# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4

inherit eutils fortran-2 toolchain-funcs multilib

DESCRIPTION="PMEL fork of XGKS, an X11-based version of the ANSI Graphical Kernel System"
HOMEPAGE="http://www.gentoogeek.org/viewvc/Linux/xgks-pmel/"
SRC_URI="http://www.gentoogeek.org/files/${P}.tar.gz"

LICENSE="UCAR-Unidata"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~ppc64 ~x86"
IUSE="doc"

RDEPEND="
	x11-libs/libX11"
DEPEND="${RDEPEND}
	sys-devel/flex
	sys-apps/groff"

src_prepare() {
	epatch "${FILESDIR}"/aclocal.patch
}

src_configure() {
	sed -i -e "s:lib64:$(get_libdir):g" port/master.mk.in \
		fontdb/Makefile.in || die

	CFLAGS=${CFLAGS} LD_X11='-L/usr/$(get_libdir) -lX11' \
		FC=$(tc-getFC) CC=$(tc-getCC) OS=linux \
		./configure --prefix=/usr --exec_prefix=/usr/bin \
		|| die
}

src_compile() {
	sed -i -e "s:port/all port/install:port/all:g" Makefile \
		|| die

	# Fails parallel build, bug #295724
	emake -j1

	cd src/fortran
	emake -j1
}

src_install() {
	cd "${S}"/progs

	for tool in {defcolors,font,mi,pline,pmark}; do
		newbin ${tool} xgks-${tool}
	done

	cd "${S}"
	dolib.a src/lib/libxgks.a

	dodoc COPYRIGHT HISTORY INSTALL README
	doman doc/{xgks.3,xgks_synop.3}
	if use doc; then
		newdoc doc/binding/cbinding.me cbinding
		newdoc doc/userdoc/userdoc.me userdoc
		insinto /usr/share/doc/${P}/examples
		doins progs/{hanoi.c,star.c}
	fi

	insinto /usr/include/xgks
	doins src/lib/gks*.h
	doins src/lib/gksm/gksm*.h
	doins src/fortran/f*.h
	doins src/lib/w*.h
	doins src/lib/{input.h,metafile.h,polylines.h,polymarkers.h,text.h}

	insinto /usr/include
	doins src/lib/xgks.h
	doins port/udposix.h

	insinto /usr/share/xgksfonts
	doins fontdb/{[1-9],*.gksfont}
}
