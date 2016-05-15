# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="2"

inherit autotools eutils multilib toolchain-funcs

MY_PN="${PN/cratch}"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="A cross-compilation toolkit designed to make embedded Linux application development easier"
HOMEPAGE="https://www.freedesktop.org/wiki/Software/sbox2"
SRC_URI="https://cgit.freedesktop.org/${MY_PN}/snapshot/${MY_P}.tar.bz2"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=">=dev-lang/lua-5.1.4"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${MY_P}"

src_prepare() {
	epatch "${FILESDIR}/${P}-glibc-2.10.patch"
	epatch "${FILESDIR}/${P}-gentoo.patch"
	# bug 296552
	epatch "${FILESDIR}/${P}-use-system-lua.patch"
	# bug 296550
	epatch "${FILESDIR}/${P}-as-needed.patch"

	sed -e "s/^\(CC = \).*/\1$(tc-getCC)/" \
		-e "s/^\(CXX = \).*/\1$(tc-getCXX)/" \
		-e "s/^\(LD = \).*/\1$(tc-getLD)/" \
		-i Makefile || die "sed Makefile failed"

	eautoreconf
}

src_compile() {
	emake prefix="${D}/usr" || die "emake failed"
}

src_install() {
	emake prefix="${D}/usr" install || die "emake install failed"

	# List all the multilib libdirs
	local libdirs=
	for libdir in $(get_all_libdirs); do
			libdirs="${libdirs}:/usr/${libdir}/libsb2"
	done

	cat <<-EOF > "${T}/55scratchbox2"
	LDPATH=${libdirs:1}
	EOF
	doenvd "${T}/55scratchbox2" || die "doenvd failed"

	dodoc AUTHORS README TODO || die "dodoc failed"
}
