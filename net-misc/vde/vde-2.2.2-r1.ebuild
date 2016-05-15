# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit eutils flag-o-matic user

MY_P="${PN}2-${PV}"
S="${WORKDIR}/${MY_P}"

DESCRIPTION="Virtual distributed ethernet emulator for emulators like qemu, bochs, and uml"
SRC_URI="mirror://sourceforge/vde/${MY_P}.tar.bz2"
HOMEPAGE="http://vde.sourceforge.net/"
SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~amd64 ~ppc ~ppc64 ~x86"

# The slirpvde-buffer-overflow patch was made by Ludwig Nussel and submitted upstream at
# http://sourceforge.net/tracker/?func=detail&aid=2138410&group_id=95403&atid=611248
PATCHES=(
	"${FILESDIR}/${P}-gcc43.patch"
	"${FILESDIR}/${P}-slirpvde-buffer-overflow.patch"
	"${FILESDIR}/${P}-gcc53.patch"
)

src_prepare() {
	epatch "${PATCHES[@]}"
	epatch_user
}

src_configure() {
	append-cflags $(test-flags-CC -fno-strict-aliasing)
	econf
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
	newinitd "${FILESDIR}"/vde.init vde
	newconfd "${FILESDIR}"/vde.conf vde

	dodoc INSTALL README
}

pkg_postinst() {
	# default group already used in kqemu
	enewgroup qemu
	einfo "To start vde automatically add it to the default runlevel:"
	einfo "# rc-update add vde default"
	einfo "You need to setup tap0 in /etc/conf.d/net"
	einfo "To use it as a user be sure to set a group in /etc/conf.d/vde"
	einfo "Users of the group can then run: $ vdeq qemu -sock /var/run/vde.ctl ..other opts"
}
