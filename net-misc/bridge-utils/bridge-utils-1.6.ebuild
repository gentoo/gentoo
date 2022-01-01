# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit autotools linux-info toolchain-funcs

DESCRIPTION="Tools for configuring the Linux kernel 802.1d Ethernet Bridge"
HOMEPAGE="http://bridge.sourceforge.net/"
#SRC_URI="mirror://sourceforge/bridge/${P}.tar.gz"
SRC_URI="https://www.kernel.org/pub/linux/utils/net/${PN}/${P}.tar.xz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 arm ~arm64 ~hppa ~ia64 ~mips ppc ~ppc64 sparc x86"
IUSE="selinux"

DEPEND="virtual/os-headers"
RDEPEND="selinux? ( sec-policy/selinux-brctl )"

CONFIG_CHECK="~BRIDGE"
WARNING_BRIDGE="CONFIG_BRIDGE is required to get bridge devices in the kernel"

get_headers() {
	CTARGET=${CTARGET:-${CHOST}}
	dir=/usr/include
	tc-is-cross-compiler && dir=/usr/${CTARGET}/usr/include
	echo "${dir}"
}

src_prepare() {
	local PATCHES=(
		"${FILESDIR}"/libbridge-substitute-AR-variable-from-configure.patch
	)
	default
	eautoreconf
}

src_configure() {
	# use santitized headers and not headers from /usr/src
	local myeconfargs=(
		--prefix=/
		--libdir=/usr/$(get_libdir)
		--includedir=/usr/include
		--with-linux-headers="$(get_headers)"
	)
	econf "${myeconfargs[@]}"
}

src_install() {
	emake install DESTDIR="${D}"
	dodoc AUTHORS ChangeLog README THANKS TODO \
		doc/{FAQ,FIREWALL,HOWTO,PROJECTS,RPM-GPG-KEY,SMPNOTES,WISHLIST}
	[ -f "${ED%/}"/sbin/brctl ] || die "upstream makefile failed to install binary"
}
