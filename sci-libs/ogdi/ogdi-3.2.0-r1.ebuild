# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MY_P=${P/_/.}
inherit toolchain-funcs

DESCRIPTION="Open Geographical Datastore Interface, a GIS support library"
HOMEPAGE="http://ogdi.sourceforge.net/"
SRC_URI="mirror://sourceforge/ogdi/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~arm arm64 ~ia64 ppc ppc64 x86 ~amd64-linux ~x86-linux"
IUSE="static-libs"

DEPEND="
	net-libs/libtirpc
	dev-libs/expat
	>=sci-libs/proj-4.9.0:=
	<sci-libs/proj-6.0.0:=
	sys-libs/zlib
"
RDEPEND="${DEPEND}"

S=${WORKDIR}/${MY_P}

DOCS=( ChangeLog NEWS README )

PATCHES=(
	"${FILESDIR}"/${PN}-3.2.0_beta2-subdirs.patch
	"${FILESDIR}"/${P}-acinclude.patch
	"${FILESDIR}"/${P}-aclocal.patch
	"${FILESDIR}"/${P}-endianess.patch
	"${FILESDIR}"/${P}-fpic.patch
	"${FILESDIR}"/${P}-ldflags.patch
	"${FILESDIR}"/${P}-optimisation.patch
	"${FILESDIR}"/${P}-rpc.patch
	"${FILESDIR}"/${P}-tcl.patch
)

src_prepare() {
	default
	rm -r external || die
	sed 's:O2:O9:g' -i configure || die
}

src_configure() {
	export TOPDIR="${S}"
	export TARGET=$(uname)
	export CFG="release"
	export LD_LIBRARY_PATH=$TOPDIR/bin/${TARGET}

	econf \
		--with-projlib="-L${EPREFIX}/usr/$(get_libdir) -lproj" \
		--with-expat \
		--with-zlib
}

src_compile() {
	# bug #299239
	emake -j1 \
		CC="$(tc-getCC)" \
		LD="$(tc-getCC)" \
		SHLIB_LD="$(tc-getCC)"
}

src_install() {
	mv "${S}"/bin/${TARGET}/*.so* "${S}"/lib/Linux/. || die "lib move failed"
	dobin "${S}"/bin/${TARGET}/*
	insinto /usr/include
	doins ogdi/include/ecs.h ogdi/include/ecs_util.h
	dolib.so lib/${TARGET}/lib*
	use static-libs && dolib.a lib/${TARGET}/static/*.a
#	dosym libogdi31.so /usr/$(get_libdir)/libogdi.so
	einstalldocs
}
