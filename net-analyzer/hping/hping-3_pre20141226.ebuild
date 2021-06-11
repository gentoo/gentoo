# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

HPING_COMMIT="3547c7691742c6eaa31f8402e0ccbb81387c1b99"
DESCRIPTION="A ping-like TCP/IP packet assembler/analyzer"
HOMEPAGE="http://www.hping.org"
SRC_URI="https://github.com/antirez/${PN}/archive/${HPING_COMMIT}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${PN}-${HPING_COMMIT}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm ~hppa ~ia64 ~mips ppc sparc x86"
IUSE="tcl"

DEPEND="
	net-libs/libpcap
	tcl? ( dev-lang/tcl:0= )
"
RDEPEND="${DEPEND}"

PATCHES=(
	"${FILESDIR}"/${PN}-3_pre20051105-libtcl.patch
	"${FILESDIR}"/${PN}-3_pre20051105-tcl.patch
	"${FILESDIR}"/${PN}-3_pre20051105-tclsh-proper-escaping.patch
	"${FILESDIR}"/${PN}-3_pre20141226-compile.patch
	"${FILESDIR}"/${PN}-3_pre20141226-hping2-2-hping.patch
	"${FILESDIR}"/${PN}-3_pre20141226-indent.patch
	"${FILESDIR}"/${PN}-3_pre20141226-pcap-bpf.patch
	"${FILESDIR}"/${PN}-3_pre20141226-scan-overflow.patch
	"${FILESDIR}"/${PN}-3_pre20141226-unused-but-set.patch
	"${FILESDIR}"/${PN}-3_pre20141226-fno-common.patch
)

src_configure() {
	tc-export CC

	# Not an autotools type configure:
	sh configure $(usex tcl '' --no-tcl) || die
}

src_compile() {
	emake \
		DEBUG="" \
		"CFLAGS=${CFLAGS}" \
		"AR=$(tc-getAR)" \
		"RANLIB=$(tc-getRANLIB)" \
		"LIBDIR=$(get_libdir)"
}

src_install() {
	dosbin hping3
	dosym hping3 /usr/sbin/hping
	dosym hping3 /usr/sbin/hping2

	newman docs/hping3.8 hping.8

	dodoc AUTHORS BUGS CHANGES INSTALL NEWS README TODO
}
