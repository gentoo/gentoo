# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs

DESCRIPTION="ITS4: Software Security Tool"
HOMEPAGE="http://www.cigital.com/its4/"
SRC_URI="https://dev.gentoo.org/~robbat2/distfiles/${P}.tgz"

LICENSE="ITS4"
SLOT="0"
KEYWORDS="~amd64 ~ppc x86"

S="${WORKDIR}/${PN}"

PATCHES=(
	"${FILESDIR}/${PN}-1.1.1-r2-cpp-headers-and-opt-flags.patch"
	"${FILESDIR}/${PN}-1.1.1-r2-ensure-spaces-in-string-literals.patch" # bug 738936
)

src_configure() {
	# WARNING
	# non-standard configure
	# do NOT use econf
	./configure --with-cpp="$(tc-getCXX)" --prefix=/usr --mandir=/usr/share/man --datadir=/usr/share/its4 || die "configure failed"
}

src_compile() {
	emake CC="$(tc-getCXX)" OPTIMIZATION="${CXXFLAGS}" EXTRA_FLAGS="${LDFLAGS}"
}

src_install() {
	# WARNING
	# non-standard, do NOT use einstall or 'make install DESTDIR=...'
	make install INSTALL_BINDIR="${D}/usr/bin" INSTALL_MANDIR="${D}/usr/share/man" INSTALL_DATADIR="${D}/usr/share/its4" || die "install failed"
}
