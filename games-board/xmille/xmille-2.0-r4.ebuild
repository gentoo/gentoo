# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit desktop flag-o-matic toolchain-funcs

DEB_PATCH_VER="13"
DESCRIPTION="Mille Bournes card game"
HOMEPAGE="http://www.milleborne.info/"
SRC_URI="mirror://debian/pool/main/x/xmille/${PN}_${PV}.orig.tar.gz
	mirror://debian/pool/main/x/xmille/${PN}_${PV}-${DEB_PATCH_VER}.diff.gz"
S="${WORKDIR}/${P}.orig"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="~amd64 ~x86"

BDEPEND="
	app-text/rman
	sys-devel/gcc
	>=x11-misc/imake-1.0.8-r1
"
RDEPEND="x11-libs/libXext"
DEPEND="${RDEPEND}"

PATCHES=(
	"${WORKDIR}"/${PN}_${PV}-${DEB_PATCH_VER}.diff
)

src_configure() {
	# bug #858620
	filter-lto

	CC="$(tc-getBUILD_CC)" LD="$(tc-getLD)" \
		IMAKECPP="${IMAKECPP:-${CHOST}-gcc -E}" xmkmf || die
}

src_compile() {
	emake -j1 \
		AR="$(tc-getAR) cq" \
		RANLIB="$(tc-getRANLIB)" \
		CC="$(tc-getCC)" \
		CDEBUGFLAGS="${CFLAGS}" \
		EXTRA_LDOPTIONS="${LDFLAGS}"
}

src_install() {
	dobin xmille
	einstalldocs
	make_desktop_entry "${PN}" "Milles Bournes"
	newman xmille.man xmille.6
}
