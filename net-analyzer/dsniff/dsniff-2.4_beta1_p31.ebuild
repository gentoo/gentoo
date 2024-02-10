# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools toolchain-funcs

MY_PV="${PV/_beta/b}"
MY_PV="${MY_PV/_p*/}"
MY_PV="$(ver_rs 1 '.' "${MY_PV}")"
# 2.4_beta1_p30 -> 2.4beta1-30
MY_DEB_PV="$(ver_cut 1-2)$(ver_cut 3-4)-$(ver_cut 6)"

DESCRIPTION="A collection of tools for network auditing and penetration testing"
HOMEPAGE="https://monkey.org/~dugsong/dsniff/"
SRC_URI="mirror://debian/pool/main/${PN::1}/${PN}/${PN}_${MY_PV}+debian.orig.tar.gz
	mirror://debian/pool/main/${PN::1}/${PN}/${PN}_${MY_PV}+debian-${PV/*_p}.debian.tar.xz"
S="${WORKDIR}/${P/_beta1*/}"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64"
IUSE="X"

# There's a berkdb configure option but we get a build failure if
# we try to disable it. Not clear how useful the package is
# without it anyway.
RDEPEND="net-libs/libpcap
	>=net-libs/libnet-1.1.2.1-r1
	>=net-libs/libnids-1.21
	net-libs/libnsl:=
	net-libs/libtirpc:=
	dev-libs/openssl:=
	>=sys-libs/db-4:=
	X? ( x11-libs/libXmu )"
DEPEND="${DEPEND}
	net-libs/rpcsvc-proto"
# Calls rpcgen during build
BDEPEND="net-libs/rpcsvc-proto"

PATCHES=(
	"${WORKDIR}"/debian/patches/
	"${FILESDIR}"/${PN}-2.4_beta1_p30-httppostfix.patch
	"${FILESDIR}"/${PN}-2.4_beta1_p30-libdir-configure.patch
	"${FILESDIR}"/${PN}-2.4_beta1_p30-respect-AR.patch
	"${FILESDIR}"/${PN}-2.4_beta1_p31-c99-fixes.patch
)

src_prepare() {
	default

	mv configure.{in,ac} || die
	eautoreconf
}

src_configure() {
	tc-export AR

	econf \
		$(use_with X x)
}

src_compile() {
	emake CC="$(tc-getCC)"
}

src_install() {
	emake install install_prefix="${D}"

	dodir /etc/dsniff
	cp "${ED}"/usr/share/dsniff/{dnsspoof.hosts,dsniff.{magic,services}} \
		"${ED}"/etc/dsniff/ || die
	dodoc CHANGES README TODO
}
