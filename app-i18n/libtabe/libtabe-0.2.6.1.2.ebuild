# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

WANT_AUTOMAKE=1.11

inherit autotools

DEBIAN_PV=$(ver_rs 3 '-')
DEBIAN_PATCH=${PN}_${DEBIAN_PV}.diff
ORIG_PV=${DEBIAN_PV%-*}
ORIG_P=${PN}-${ORIG_PV}

DESCRIPTION="Libtabe provides bimsphone support for xcin-2.5+"
HOMEPAGE="https://packages.qa.debian.org/libt/libtabe.html"
SRC_URI="
	mirror://debian/pool/main/${PN:0:4}/${PN}/${PN}_${ORIG_PV}.orig.tar.gz
	mirror://debian/pool/main/${PN:0:4}/libtabe/${DEBIAN_PATCH}.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ppc x86"
IUSE="debug"

RDEPEND=">=sys-libs/db-4.5:="
DEPEND="
	${RDEPEND}
	x11-libs/libX11"

S=${WORKDIR}/${ORIG_P}.orig

PATCHES=(
	"${WORKDIR}"/${DEBIAN_PATCH}
	"${FILESDIR}"/${ORIG_P}-fabs.patch
	"${FILESDIR}"/${ORIG_P}-ldflags.patch
)

src_prepare() {
	default

	ln -s script/configure.in configure.ac || die
	eautoreconf
}

src_configure() {
	econf \
		--with-db-inc="${EPREFIX}"/usr/include \
		--with-db-lib="${EPREFIX}"/usr/$(get_libdir) \
		--with-db-bin="${EPREFIX}"/usr/bin \
		--with-db-name=db \
		--enable-shared \
		--disable-static \
		$(use_enable debug)
}

src_compile() {
	# We execute this serially because the Makefiles don't handle
	# proper cross-directory references.
	emake -C src
	emake -C util
	emake -C tsi-src
}

src_install() {
	default
	dodoc -r doc/.

	# no static archives
	find "${D}" -name '*.la' -delete || die
}
