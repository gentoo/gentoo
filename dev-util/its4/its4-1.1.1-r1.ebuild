# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="5"

inherit eutils

DESCRIPTION="ITS4: Software Security Tool"
HOMEPAGE="http://www.cigital.com/its4/"
SRC_URI="https://dev.gentoo.org/~robbat2/distfiles/${P}.tgz"
LICENSE="ITS4"
SLOT="0"
KEYWORDS="~amd64 ppc x86"
IUSE=""

DEPEND=""
RDEPEND=""

S="${WORKDIR}/${PN}"

src_prepare() {
	sed -i \
		-e 's,iostream.h,iostream,g'\
		"${S}"/configure || die
	sed -i \
		-e 's/$(CC) -o/$(CC) $(OPTIMIZATION) $(EXTRA_FLAGS) -o/' \
		"${S}"/Makefile.in || die
}

src_configure() {
	# WARNING
	# non-standard configure
	# do NOT use econf
	./configure --prefix=/usr --mandir=/usr/share/man --datadir=/usr/share/its4 || die "configure failed"
}

src_compile() {
	emake CC="$(tc-getCXX)" OPTIMIZATION="${CXXFLAGS}" EXTRA_FLAGS="${LDFLAGS}"
}

src_install() {
	# WARNING
	# non-standard, do NOT use einstall or 'make install DESTDIR=...'
	make install INSTALL_BINDIR="${D}/usr/bin" INSTALL_MANDIR="${D}/usr/share/man" INSTALL_DATADIR="${D}/usr/share/its4" || die "install failed"
}
