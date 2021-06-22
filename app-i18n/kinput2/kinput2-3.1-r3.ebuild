# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

MY_P="${PN}-v${PV}"

DESCRIPTION="A Japanese input server which supports the XIM protocol"
HOMEPAGE="http://www.nec.co.jp/canna"
SRC_URI="ftp://ftp.sra.co.jp/pub/x11/${PN}/${MY_P}.tar.gz"
S="${WORKDIR}/${MY_P}"

LICENSE="HPND"
SLOT="0"
KEYWORDS="amd64 ppc ppc64 sparc x86"

RDEPEND="
	app-i18n/freewnn
	x11-libs/libICE
	x11-libs/libSM
	x11-libs/libX11
	x11-libs/libXaw
	x11-libs/libXext
	x11-libs/libXmu
	x11-libs/libXpm
	x11-libs/libXt"
DEPEND="${RDEPEND}"
BDEPEND="
	x11-misc/gccmakedep
	>=x11-misc/imake-1.0.8-r1"

PATCHES=(
	"${FILESDIR}"/${PN}-gentoo.patch
	"${FILESDIR}"/${PN}-headers.patch
	"${FILESDIR}"/${PN}-ppc.patch
	"${FILESDIR}"/${PN}-segfault.patch
	"${FILESDIR}"/${PN}-wnn.patch
)

src_prepare() {
	default
	sed -i "s|^/\* \(#define UseWnn\) \*/|\1|" ${PN^k}.conf || die
}

src_configure() {
	CC="$(tc-getBUILD_CC)" LD="$(tc-getLD)" \
		IMAKECPP="${IMAKECPP:-$(tc-getCPP)}" xmkmf -a || die
}

src_compile() {
	emake \
		AR="$(tc-getAR) cq" \
		CC="$(tc-getCC)" \
		RANLIB="$(tc-getRANLIB)" \
		CDEBUGFLAGS="${CFLAGS}" \
		LOCAL_LDFLAGS="${LDFLAGS}" \
		XAPPLOADDIR="${EPREFIX}/usr/share/X11/app-defaults"
}

src_install() {
	emake \
		XAPPLOADDIR="${EPREFIX}/usr/share/X11/app-defaults" \
		DESTDIR="${D}" \
		install

	einstalldocs
	dodoc -r doc/.
	newman cmd/${PN}.man ${PN}.1

	rm -rf "${ED}"/usr/$(get_libdir)/X11 || die

	insinto /etc/X11/xinit/xinput.d
	sed \
		-e "s:@EPREFIX@:${EPREFIX}:g" \
		-e "s:@SERVER@:wnn:g" \
		"${FILESDIR}"/xinput-${PN} > "${T}"/${PN}.conf || die
	doins "${T}"/${PN}.conf
}
