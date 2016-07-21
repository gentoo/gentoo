# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4
inherit eutils toolchain-funcs

DESCRIPTION="An sound server for the WindowMaker desktop"
HOMEPAGE="http://windowmaker.org/"
SRC_URI="mirror://gentoo/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~ppc ~x86"
IUSE=""

RDEPEND="media-sound/wmsound-data
	x11-libs/libproplist
	x11-wm/windowmaker"
DEPEND="${RDEPEND}
	x11-misc/gccmakedep
	x11-misc/imake"

src_prepare() {
	epatch \
		"${FILESDIR}"/${PN}-config.patch \
		"${FILESDIR}"/${PN}-ComplexProgramTargetNoMan.patch

	# Fix building with -Wl,--as-needed
	sed -i \
		-e 's:-lPropList $(WMSOUNDLIB):$(WMSOUNDLIB) -lPropList:' \
		src/Imakefile || die
	sed -i \
		-e 's:-lPropList $(XLIB) $(WMSOUNDLIB):$(WMSOUNDLIB) -lPropList	$(XLIB):' \
		utils/Imakefile || die
}

src_compile() {
	xmkmf -a || die
	emake CC="$(tc-getCC)" CDEBUGFLAGS="${CFLAGS}" LDOPTIONS="${LDFLAGS}"
}

src_install() {
	emake DESTDIR="${D}/usr" install
	dodoc AUTHORS BUGS ChangeLog

	# Remove libwmsnd.a and wmsnd.h because they are unused, see:
	# https://qa-reports.gentoo.org/output/genrdeps/dindex/media-sound/wmsound
	rm -rf "${ED}"/usr/{include,lib*}
}
