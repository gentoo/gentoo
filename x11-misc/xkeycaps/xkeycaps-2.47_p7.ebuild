# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit toolchain-funcs

DESCRIPTION="GUI frontend to xmodmap"
HOMEPAGE="https://packages.qa.debian.org/x/xkeycaps.html"
SRC_URI="
	mirror://debian/pool/main/x/${PN}/${PN}_${PV/_p*}.orig.tar.gz
	mirror://debian/pool/main/x/${PN}/${PN}_${PV/_p/-}.debian.tar.xz
"

LICENSE="HPND"
SLOT="0"
KEYWORDS="amd64 ppc ppc64 x86"

RDEPEND="
	x11-libs/libX11
	x11-libs/libXaw
	x11-libs/libXext
	x11-libs/libXmu
	x11-libs/libXt
	x11-misc/xbitmaps
"
DEPEND="
	${RDEPEND}
	x11-base/xorg-proto
"
BDEPEND="
	sys-devel/gcc
	>=x11-misc/imake-1.0.8-r1
"

DOCS=( README defining.txt hierarchy.txt sgi-microsoft.txt )
PATCHES=(
	"${FILESDIR}"/${P/_p*}-Imakefile.patch
	"${FILESDIR}"/${P}-clang16.patch
)
S=${WORKDIR}/${P/_p*}

src_prepare() {
	eapply $(
		for file in $(cat "${WORKDIR}"/debian/patches/series)
			do echo "${WORKDIR}"/debian/patches/${file}
		done
	)
	default
}

src_configure() {
	CC="$(tc-getBUILD_CC)" LD="$(tc-getLD)" \
		IMAKECPP="${IMAKECPP:-${CHOST}-gcc -E}" xmkmf || die
	sed -i \
		-e "s,all:: xkeycaps.\$(MANSUFFIX).html,all:: ,g" \
		Makefile || die
}

src_compile() {
	emake \
		CC="$(tc-getCC)" \
		CDEBUGFLAGS="${CFLAGS}"
}

src_install() {
	default
	newman ${PN}.man ${PN}.1
}
