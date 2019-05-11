# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

WANT_AUTOMAKE="1.10"

inherit autotools

MY_PN="Pixie"
S="${WORKDIR}/${MY_PN}"

DESCRIPTION="RenderMan like photorealistic renderer"
HOMEPAGE="http://www.okanarikan.com/project/2005/05/24/Pixie.html"
SRC_URI="mirror://sourceforge/${PN}/${MY_PN}-src-${PV}.tgz https://dev.gentoo.org/~dilfridge/distfiles/pixie-2.2.6-gcc6.patch.gz"

LICENSE="GPL-2+"
IUSE="X static-libs"
SLOT="0"
KEYWORDS="amd64 ppc ~sparc x86"

RDEPEND="media-libs/libpng
	media-libs/tiff
	media-libs/openexr
	sys-libs/zlib
	virtual/jpeg
	virtual/opengl
	x11-libs/fltk:1[opengl]
	X? (
		x11-libs/libICE
		x11-libs/libSM
		x11-libs/libX11
		x11-libs/libXau
		x11-libs/libxcb
		x11-libs/libXdmcp
		x11-libs/libXext
		x11-libs/libXi
		x11-libs/libXmu
		x11-libs/libXt
	)"
DEPEND="${RDEPEND}
	sys-devel/bison
	sys-devel/flex"

src_prepare() {
	default
	eapply "${FILESDIR}"/${P}-zlib-1.2.5.2.patch
	# FIX: missing @includedir@
	# https://sf.net/tracker/?func=detail&aid=2923415&group_id=59462&atid=491094
	eapply "${FILESDIR}"/${P}-autotools.patch
	# bug 594354
	eapply "${WORKDIR}"/${P}-gcc6.patch

	mv configure.{in,ac} || die

	eautoreconf

	# FIX: removing pre-compiled shaders
	# shaders must be removed before of their compilation or make
	# parallelism can break the regeneration process, with resulting
	# missing shaders.
	rm "${S}"/shaders/*.sdr || die

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
	default

	# regenerating Pixie shaders - see upstream bug report:
	# https://sf.net/tracker/?func=detail&aid=2923407&group_id=59462&atid=491094
	einfo "Re-building Pixie Shaders for v${PV} format"
	emake -f "${FILESDIR}/Makefile.shaders" -C "${S}/shaders"
}

src_install() {
	default

	insinto /usr/share/Pixie/textures
	doins "${S}"/textures/*

	# remove useless .la files
	find "${D}" -name '*.la' -delete || die "removal of libtool archive files failed"
}
