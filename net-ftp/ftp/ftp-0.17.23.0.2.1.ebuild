# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

inherit eutils toolchain-funcs flag-o-matic versionator

PATCH_VER="2"
MY_PN="netkit-ftp"
MY_PV="$(get_version_component_range 1-2)"
MY_P="netkit-${PN}-${MY_PV}"
DEB_PN="${MY_PN}-ssl"
DEB_PV="$(get_version_component_range 1-3)+$(get_version_component_range 4-5)-$(get_version_component_range 6)"
DESCRIPTION="Standard Linux FTP client"
HOMEPAGE="http://www.hcs.harvard.edu/~dholland/computers/netkit.html"
SRC_URI="ftp://sunsite.unc.edu/pub/Linux/system/network/netkit/${MY_P}.tar.gz
	mirror://debian/pool/main/n/${DEB_PN}/${DEB_PN}_${DEB_PV}.debian.tar.gz
	mirror://gentoo/${MY_P}-patches-${PATCH_VER}.tar.bz2"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86"
IUSE="ipv6 readline ssl"

RDEPEND=">=sys-libs/ncurses-5.2:=
	readline? ( sys-libs/readline:0= )
	ssl? ( dev-libs/openssl:0= )"
DEPEND="${RDEPEND}"

S=${WORKDIR}/${MY_P}

src_prepare() {
	EPATCH_FORCE="yes" EPATCH_SUFFIX="diff" epatch "${WORKDIR}"/debian/patches
	EPATCH_SUFFIX="patch" epatch "${WORKDIR}"/patch
	sed -i \
		-e 's:echo -n:printf %s :' \
		configure || die
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
