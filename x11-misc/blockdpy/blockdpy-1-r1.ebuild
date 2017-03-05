# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit toolchain-funcs

DESCRIPTION="Tool to block access via the physical display while x11vnc is running"
HOMEPAGE="http://www.karlrunge.com/x11vnc/blockdpy.c"
SRC_URI="http://www.karlrunge.com/x11vnc/blockdpy.c"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="
	x11-libs/libX11
	x11-libs/libXext"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

S=${WORKDIR}

src_unpack() {
	cp "${DISTDIR}"/blockdpy.c blockdpy.c || die
}

src_prepare() {
	default

	# Add includes to avoid QA warnings.
	sed -i '/#include <stdio.h>/i#include <stdlib.h>' blockdpy.c || die
	sed -i '/#include <stdio.h>/i#include <string.h>' blockdpy.c || die
}

src_compile() {
	$(tc-getCC) ${CFLAGS} ${CPPFLAGS} ${LDFLAGS} \
		$($(tc-getPKG_CONFIG) --cflags x11) \
		$($(tc-getPKG_CONFIG) --cflags xext) \
		-o blockdpy blockdpy.c \
		$($(tc-getPKG_CONFIG) --libs x11) \
		$($(tc-getPKG_CONFIG) --libs xext) \
			|| die "compile failed"

	# Create README from head comment in source.
	sed -n '1,/^ *\*\//s/^[ -]*\*[ \/]*//p' < blockdpy.c > README || die
}

src_install() {
	dobin blockdpy
	einstalldocs
}

pkg_postinst() {
	# Just warn about missing xlock instead of requiring it in case
	# the user wants to use something else.
	if [[ ! -x ${EPREFIX}/usr/bin/xlock ]]; then
		ewarn 'The xlock executable was not found.'
		ewarn 'blockdpy runs "xlock" as the screen-lock program by default.'
		ewarn 'You should either install x11-misc/xlockmore or override the'
		ewarn 'default by calling blockdpy with the -lock option or by'
		ewarn 'setting the XLOCK_CMD environment variable.'
		ewarn
		ewarn "  Examples:  blockdpy -lock 'xscreensaver-command -lock'"
		ewarn "             blockdpy -lock 'kdesktop_lock --forcelock'"
		ewarn
	fi
}
