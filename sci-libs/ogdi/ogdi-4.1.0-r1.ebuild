# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Open Geographical Datastore Interface, a GIS support library"
HOMEPAGE="http://ogdi.sourceforge.net/ https://github.com/libogdi/ogdi"
SRC_URI="https://github.com/libogdi/ogdi/releases/download/${PN}_${PV//./_}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~arm arm64 ~ia64 ppc ppc64 ~riscv x86 ~amd64-linux ~x86-linux"
IUSE=""

DEPEND="
	dev-libs/expat
	net-libs/libtirpc:=
	sys-libs/zlib
"
RDEPEND="${DEPEND}"

DOCS=( ChangeLog NEWS README )

PATCHES=(
	"${FILESDIR}"/${P}-subdirs.patch
	"${FILESDIR}"/${PN}-3.2.0-endianess.patch
	"${FILESDIR}"/${PN}-3.2.0-optimisation.patch
	"${FILESDIR}"/${PN}-3.2.0-tcl.patch
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
		--with-expat \
		--with-zlib
}

src_compile() {
	# bug #299239
	emake -j1
}

src_install() {
	mv "${S}"/bin/${TARGET}/*.so* "${S}"/lib/Linux/. || die "lib move failed"
	dobin "${S}"/bin/${TARGET}/*

	insinto /usr/include
	doins ogdi/include/ecs.h ogdi/include/ecs_util.h

	dolib.so lib/${TARGET}/lib*

	insinto "/usr/$(get_libdir)/pkgconfig"
	doins ogdi.pc

	dobin ogdi-config

	einstalldocs
}
