# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

DESCRIPTION="ITS4: Software Security Tool"
HOMEPAGE="http://www.cigital.com/its4/"
SRC_URI="https://dev.gentoo.org/~robbat2/distfiles/${P}.tgz"
LICENSE="ITS4"
SLOT="0"
KEYWORDS="x86 ppc"
IUSE=""
DEPEND="sys-devel/gcc"
#RDEPEND=""
S="${WORKDIR}/${PN}"

src_unpack() {
	unpack ${A}
	sed -i \
		-e 's,iostream.h,iostream,g'\
		"${S}"/configure
}

src_compile() {
	# WARNING
	# non-standard configure
	# do NOT use econf
	./configure --prefix=/usr --mandir=/usr/share/man --datadir=/usr/share/its4 || die "configure failed"
	emake OPTIMIZATION="${CXXFLAGS}" || die "emake failed"
}

src_install() {
	# WARNING
	# non-standard, do NOT use einstall or 'make install DESTDIR=...'
	make install INSTALL_BINDIR="${D}/usr/bin" INSTALL_MANDIR="${D}/usr/share/man" INSTALL_DATADIR="${D}/usr/share/its4" || die "install failed"
}
