# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit autotools toolchain-funcs

DESCRIPTION="A collection of tools for network auditing and penetration testing"
HOMEPAGE="https://monkey.org/~dugsong/dsniff/"
SRC_URI="
	https://monkey.org/~dugsong/${PN}/beta/${P/_beta/b}.tar.gz
	mirror://debian/pool/main/d/${PN}/${PN}_2.4b1+debian-22.1.debian.tar.gz
"
LICENSE="BSD"

SLOT="0"
KEYWORDS="amd64 ~ppc ~x86"
IUSE="libressl X"

DEPEND="net-libs/libpcap
	>=net-libs/libnet-1.1.2.1-r1
	>=net-libs/libnids-1.21
	net-libs/libnsl:0=
	net-libs/libtirpc
	net-libs/rpcsvc-proto
	!libressl? ( dev-libs/openssl:0= )
	libressl? ( dev-libs/libressl:0= )
	>=sys-libs/db-4:*
	X? ( x11-libs/libXmu )"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${P/_beta1/}"

src_prepare() {
	# replace Debian patch 23 with a simpler one (bug #506076)
	mv -v \
		"${WORKDIR}"/debian/patches/23_urlsnarf_timestamp.patch{,.old} || die
	cp -v \
		"${FILESDIR}"/${PV}-urlsnarf-pcap_timestamps.patch \
		"${WORKDIR}"/debian/patches/23_urlsnarf_timestamp.patch || die

	# Debian patchset, needs to be applied in the exact order that "series"
	# lists or patching will fail.
	# Bug #479882
	eapply $(
		for file in $(< "${WORKDIR}"/debian/patches/series ); do
			printf "%s/debian/patches/%s " "${WORKDIR}" "${file}"
		done
	)

	# Bug 125084
	eapply "${FILESDIR}"/${PV}-httppostfix.patch

	# various Makefile.in patches
	eapply "${FILESDIR}"/${PV}-make.patch

	# bug #538462
	eapply "${FILESDIR}"/${PV}-macof-size-calculation.patch

	# libtirpc support
	eapply "${FILESDIR}"/${PV}-rpc.patch

	default
	eautoreconf
}

src_configure() {
	econf \
		--with-libtirpc \
		$(use_with X x) \
		|| die "econf failed"
}

src_compile() {
	emake CC="$(tc-getCC)"
}

src_install() {
	emake install install_prefix="${D}"
	dodir /etc/dsniff
	cp "${D}"/usr/share/dsniff/{dnsspoof.hosts,dsniff.{magic,services}} \
		"${D}"/etc/dsniff/ || die
	dodoc CHANGES README TODO
}
