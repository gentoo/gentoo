# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="2"

WANT_AUTOMAKE="1.10"

inherit eutils multilib autotools

MY_PN="Pixie"
S="${WORKDIR}/${MY_PN}"

DESCRIPTION="RenderMan like photorealistic renderer"
HOMEPAGE="http://pixie.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${MY_PN}-src-${PV}.tgz"

LICENSE="GPL-2"
IUSE="X static-libs"
SLOT="0"
KEYWORDS="amd64 ~ppc sparc x86"

RDEPEND="virtual/jpeg
	media-libs/tiff
	media-libs/libpng
	x11-libs/fltk:1[opengl]
	media-libs/openexr
	virtual/opengl
	sys-libs/zlib
	X? (
		x11-libs/libXext
		x11-libs/libICE
		x11-libs/libSM
		x11-libs/libX11
		x11-libs/libXau
		x11-libs/libxcb
		x11-libs/libXdmcp
		x11-libs/libXi
		x11-libs/libXmu
		x11-libs/libXt
	)"
DEPEND="${RDEPEND}
	sys-devel/flex
	sys-devel/bison"

src_prepare() {
	epatch "${FILESDIR}"/${P}-zlib-1.2.5.2.patch
	# FIX: missing @includedir@
	# https://sf.net/tracker/?func=detail&aid=2923415&group_id=59462&atid=491094
	epatch "${FILESDIR}"/${P}-autotools.patch
	eautoreconf

	# FIX: removing pre-compiled shaders
	# shaders must be removed before of their compilation or make
	# parallelism can break the regeneration process, with resulting
	# missing shaders.
	rm "${S}"/shaders/*.sdr

	# FIX: flex does not translate variable name in custom YY_DECL
	sed -i -e '/define YY_DECL/ s/yylval/riblval/' src/ri/rib.l || die
}

src_configure() {
	# NOTE: the option program-transform-name is used to avoid binary name
	# conflict with package: mail-client/nmh (see #295996)
	econf \
		$(use_with X x) \
		$(use_enable static-libs static) \
		--includedir=/usr/include/pixie \
		--libdir=/usr/$(get_libdir)/pixie \
		--with-docdir=/usr/share/doc/${PF}/html \
		--with-shaderdir=/usr/share/Pixie/shaders \
		--with-ribdir=/usr/share/Pixie/ribs \
		--with-texturedir=/usr/share/Pixie/textures \
		--with-displaysdir=/usr/$(get_libdir)/pixie/displays \
		--with-modulesdir=/usr/$(get_libdir)/pixie/modules \
		--enable-openexr-threads \
		--disable-static-fltk \
		--mandir=/usr/share/man \
		--bindir=/usr/bin \
		--program-transform-name="s/show/pixie-show/"
}

src_compile() {
	emake || die "emake failed"

	# regenerating Pixie shaders - see upstream bug report:
	# https://sf.net/tracker/?func=detail&aid=2923407&group_id=59462&atid=491094
	einfo "Re-building Pixie Shaders for v${PV} format"
	emake -f "${FILESDIR}/Makefile.shaders" -C "${S}/shaders" || die "shaders rebuild failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "installation failed."

	insinto /usr/share/Pixie/textures
	doins "${S}"/textures/*

	# remove useless .la files
	find "${D}" -name '*.la' -delete || die "removal of libtool archive files failed"

	dodoc README AUTHORS ChangeLog || die
}
