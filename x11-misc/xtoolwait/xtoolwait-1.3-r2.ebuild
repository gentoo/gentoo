# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

DESCRIPTION="Xtoolwait notably decreases the startup time of an X session"
HOMEPAGE="http://ftp.x.org/contrib/utilities/xtoolwait-1.3.README"
SRC_URI="http://ftp.x.org/contrib/utilities/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc x86"

RDEPEND="
	x11-libs/libX11
	x11-libs/libXext"
DEPEND="${RDEPEND}"
BDEPEND="
	app-text/rman
	x11-base/xorg-proto
	>=x11-misc/imake-1.0.8-r1"

src_configure() {
	CC="$(tc-getBUILD_CC)" LD="$(tc-getLD)" \
		IMAKECPP="${IMAKECPP:-$(tc-getCPP)}" xmkmf || die
}

src_compile() {
	emake \
		CC="$(tc-getCC)" \
		CDEBUGFLAGS="${CFLAGS}" \
		EXTRA_LDOPTIONS="${LDFLAGS}"
}

src_install() {
	emake \
		BINDIR="${EPREFIX}"/usr/bin \
		MANPATH="${EPREFIX}"/usr/share/man \
		DOCDIR="${EPREFIX}"/usr/share/doc/${PF} \
		DESTDIR="${D}" \
		install{,.man}

	einstalldocs
}
