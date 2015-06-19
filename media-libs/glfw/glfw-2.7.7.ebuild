# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/glfw/glfw-2.7.7.ebuild,v 1.5 2015/03/25 13:52:55 ago Exp $

EAPI=5
inherit eutils multilib toolchain-funcs

DESCRIPTION="The Portable OpenGL FrameWork"
HOMEPAGE="http://www.glfw.org/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.bz2"

LICENSE="ZLIB"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="examples static-libs"

DEPEND="x11-libs/libX11
	x11-libs/libXrandr
	virtual/glu
	virtual/opengl"
RDEPEND="${DEPEND}"

src_prepare() {
	sed -i \
		-e "s:\"docs/:\"/usr/share/doc/${PF}/pdf/:" \
		readme.html || die

	epatch "${FILESDIR}"/${P}-{dyn,pkgconfig}.patch

	# respect ldflags
	sed -i \
		-e "s/\$(LFLAGS)/\$(LDFLAGS) \$(LFLAGS)/" \
		{lib/x11,examples}/Makefile.x11.in || die

	# respect cflags in linking command
	# build system is messing up CFLAGS variable, so sed is the easy way to go
	sed -i \
		-e "/^libglfw.so/{n;s/\$(CC)/\$(CC) ${CFLAGS}/;}" \
		lib/x11/Makefile.x11.in || die

	if use !static-libs ; then
		sed -i \
			-e '/^all:/s/libglfw.a//' \
			lib/x11/Makefile.x11.in || die
	fi
}

src_configure() {
	sh ./compile.sh
}

src_compile() {
	emake -C lib/x11 AR=$(tc-getAR) CC=$(tc-getCC) PREFIX=/usr LIBDIR=$(get_libdir) -f Makefile.x11 all libglfw.pc
	use examples && emake -C examples CC=$(tc-getCC) -f Makefile.x11 all
}

src_install() {
	use static-libs && dolib.a lib/x11/libglfw.a
	dolib.so lib/x11/libglfw.so.2.7.7
	dosym libglfw.so.2.7.7 /usr/$(get_libdir)/libglfw.so

	insinto /usr/$(get_libdir)/pkgconfig
	doins lib/x11/libglfw.pc
	doheader -r include/GL
	dohtml -r readme.html
	insinto /usr/share/doc/${PF}/pdf
	doins docs/*.pdf
	dodoc docs/readme.txt

	if use examples; then
		local f
		local MY_EXAMPLES="boing gears listmodes mipmaps
			mtbench mthello particles pong3d splitview
			triangle wave"
		local MY_PICS="mipmaps.tga pong3d_field.tga pong3d_instr.tga
			pong3d_menu.tga pong3d_title.tga
			pong3d_winner1.tga pong3d_winner2.tga"

		docompress -x /usr/share/doc/${PF}/examples
		insinto /usr/share/doc/${PF}/examples

		doins examples/Makefile.x11
		for f in $MY_EXAMPLES; do
			doins examples/${f}.c
		done
		for f in $MY_PICS; do
			doins examples/${f}
		done

		insopts -m0755
		for f in $MY_EXAMPLES; do
			doins examples/${f}
		done
	fi
}
