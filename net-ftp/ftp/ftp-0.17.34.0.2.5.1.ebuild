# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit flag-o-matic toolchain-funcs

PATCH_VER="3"
MY_PN="netkit-ftp"
MY_PV="$(ver_cut 1-2)"
MY_P="netkit-${PN}-${MY_PV}"
DEB_PN="${MY_PN}-ssl"
DEB_PV="$(ver_cut 1-3)+$(ver_cut 4-5)-$(ver_cut 6-7)"
DESCRIPTION="Standard Linux FTP client"
HOMEPAGE="http://www.hcs.harvard.edu/~dholland/computers/netkit.html"
SRC_URI="ftp://sunsite.unc.edu/pub/Linux/system/network/netkit/${MY_P}.tar.gz
	mirror://debian/pool/main/n/${DEB_PN}/${DEB_PN}_${DEB_PV}.debian.tar.xz
	https://dev.gentoo.org/~sam/distfiles/${CATEGORY}/${PN}/${MY_P}-patches-${PATCH_VER}.tar.bz2"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~alpha amd64 arm ~hppa ~ia64 ~mips ppc ppc64 ~riscv ~s390 sparc x86"
IUSE="ipv6 readline ssl"

RDEPEND="
	>=sys-libs/ncurses-5.2:=
	readline? ( sys-libs/readline:0= )
	ssl? ( dev-libs/openssl:0= )
"
DEPEND="${RDEPEND}"
BDEPEND="sys-apps/grep"

S=${WORKDIR}/${MY_P}

src_prepare() {
	local p
	for p in $(grep -v "^#" "${WORKDIR}"/debian/patches/series || die); do
		eapply "${WORKDIR}/debian/patches/${p}"
	done

	eapply "${WORKDIR}"/patch

	sed -i \
		-e 's:echo -n:printf %s :' \
		configure || die

	default
}

src_configure() {
	append-lfs-flags #101038
	tc-export CC
	# not an autoconf script
	./configure \
		--prefix=/usr \
		$(use_enable ipv6) \
		$(use_enable readline) \
		$(use_enable ssl) \
		|| die
}

src_install() {
	dobin ftp/ftp
	doman ftp/ftp.1 ftp/netrc.5
	dodoc ChangeLog README BUGS
}
