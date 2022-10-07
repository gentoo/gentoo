# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit edo flag-o-matic toolchain-funcs

PATCH_VER="3"
MY_PN="netkit-ftp"
MY_PV="$(ver_cut 1-2)"
MY_P="netkit-${PN}-${MY_PV}"
DEB_PN="${MY_PN}-ssl"
DEB_PV="$(ver_cut 1-3)+$(ver_cut 4-5)-$(ver_cut 6-7)"

DESCRIPTION="Standard Linux FTP client"
HOMEPAGE="https://wiki.linuxfoundation.org/networking/netkit"
SRC_URI="http://ftp.linux.org.uk/pub/linux/Networking/netkit/${MY_P}.tar.gz
	ftp://sunsite.unc.edu/pub/Linux/system/network/netkit/${MY_P}.tar.gz
	mirror://debian/pool/main/n/${DEB_PN}/${DEB_PN}_${DEB_PV}.debian.tar.xz
	https://dev.gentoo.org/~sam/distfiles/${CATEGORY}/${PN}/${MY_P}-patches-${PATCH_VER}.tar.bz2"
S="${WORKDIR}"/${MY_P}

LICENSE="BSD"
SLOT="0"
KEYWORDS="~alpha amd64 arm ~arm64 ~hppa ~ia64 ~mips ppc ppc64 ~riscv ~s390 sparc x86"
IUSE="ipv6 readline ssl"

RDEPEND="
	>=sys-libs/ncurses-5.2:=
	elibc_musl? ( sys-libs/obstack-standalone )
	readline? ( sys-libs/readline:= )
	ssl? ( dev-libs/openssl:= )
"
DEPEND="${RDEPEND}"
BDEPEND="sys-apps/grep"

src_prepare() {
	local p
	for p in $(grep -v "^#" "${WORKDIR}"/debian/patches/series || die); do
		eapply "${WORKDIR}"/debian/patches/${p}
	done

	eapply "${WORKDIR}"/patch
	eapply "${FILESDIR}"/${PN}-0.17.34.0.2.5.1-musl-glob-brace.patch

	# Drop bashism from configure
	sed -i \
		-e 's:echo -n:printf %s :' \
		configure || die

	default
}

src_configure() {
	# bug #101038
	append-lfs-flags
	tc-export CC

	# Not an autoconf script
	edo ./configure \
		--prefix=/usr \
		$(use_enable ipv6) \
		$(use_enable readline) \
		$(use_enable ssl)

	if use elibc_musl ; then
		sed -i -e '/^LIBS=/ s/$/ -lobstack/' MCONFIG || die
	fi
}

src_install() {
	dobin ftp/ftp
	doman ftp/ftp.1 ftp/netrc.5
	dodoc ChangeLog README BUGS
}
