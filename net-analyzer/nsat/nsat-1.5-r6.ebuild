# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools toolchain-funcs

DESCRIPTION="Network Security Analysis Tool, an application-level network security scanner"
HOMEPAGE="https://nsat.sourceforge.net/"
SRC_URI="mirror://sourceforge/nsat/${P}.tgz"
S="${WORKDIR}/${PN}"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~ppc x86"
IUSE="X"

RDEPEND="
	dev-libs/libmix
	net-libs/libnsl:0=
	net-libs/libpcap
	net-libs/libtirpc:=
	net-libs/rpcsvc-proto
	X? (
		dev-lang/tk:*
		x11-libs/libX11
	)
"
DEPEND="${RDEPEND}"

PATCHES=(
	"${FILESDIR}"/${P}-configure.patch
	"${FILESDIR}"/${P}-lvalue-gcc4.patch
	"${FILESDIR}"/${P}-strip.patch
	"${FILESDIR}"/${P}-misc.patch
	"${FILESDIR}"/${P}-va_list.patch
	"${FILESDIR}"/${P}-libtirpc.patch
	"${FILESDIR}"/${P}-amd64-compat.patch
	"${FILESDIR}"/${P}-configure-dash.patch
)

src_prepare() {
	default

	sed -i \
		-e "s:^#CGIFile /usr/local/share/nsat/nsat.cgi$:#CGIFile /usr/share/nsat/nsat.cgi:g" \
		nsat.conf || die
	sed -i -e "s:/usr/local:/usr:g" tools/xnsat || die
	sed -i \
		-e "s:/usr/local/share/nsat/nsat.conf:/etc/nsat/nsat.conf:g" \
		-e "s:/usr/local/share/nsat/nsat.cgi:/usr/share/nsat/nsat.cgi:g" \
		src/lang.h || die

	mv configure.{in,ac} || die

	eautoreconf
}

src_configure() {
	tc-export CC
	econf $(use_with X x)
}

src_compile() {
	emake MIXOBJ=-lmix++
}

src_install() {
	dobin nsat smb-ns
	use X && dobin tools/xnsat

	insinto /usr/share/nsat
	doins nsat.cgi

	insinto /etc/nsat
	doins nsat.conf

	dodoc README doc/CHANGES
	doman doc/nsat.8
}
