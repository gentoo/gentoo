# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-misc/chrony/chrony-1.31.1.ebuild,v 1.7 2015/04/29 09:18:51 ago Exp $

EAPI=5
inherit eutils systemd toolchain-funcs

DESCRIPTION="NTP client and server programs"
HOMEPAGE="http://chrony.tuxfamily.org/"
SRC_URI="http://download.tuxfamily.org/${PN}/${P/_/-}.tar.gz"
LICENSE="GPL-2"
SLOT="0"

KEYWORDS="amd64 ~arm hppa ~mips ppc ppc64 sparc x86"
IUSE="caps ipv6 libedit readline +rtc selinux"
REQUIRED_USE="?? ( libedit readline )"

CDEPEND="
	caps? ( sys-libs/libcap )
	libedit? ( dev-libs/libedit )
	readline? ( >=sys-libs/readline-4.1-r4 )
"
DEPEND="
	${CDEPEND}
	sys-apps/texinfo
"
RDEPEND="
	${CDEPEND}
	selinux? ( sec-policy/selinux-chronyd )
"

RESTRICT=test

S="${WORKDIR}/${P/_/-}"

src_prepare() {
	sed -i \
		-e 's:/etc/chrony\.:/etc/chrony/chrony.:g' \
		-e 's:/var/run:/run:g' \
		conf.c chrony.texi.in chrony.txt examples/* FAQ || die
}

src_configure() {
	tc-export CC

	local CHRONY_EDITLINE
	# ./configure legend:
	# --disable-readline : disable line editing entirely
	# --without-readline : do not use sys-libs/readline (enabled by default)
	# --without-editline : do not use dev-libs/libedit (enabled by default)
	if ! use readline && ! use libedit; then
		CHRONY_EDITLINE='--disable-readline'
	else
		CHRONY_EDITLINE+=" $(usex readline '' --without-readline)"
		CHRONY_EDITLINE+=" $(usex libedit '' --without-editline)"
	fi

	# not an autotools generated script
	local CHRONY_CONFIGURE="
	./configure \
		$(usex caps '' --disable-linuxcaps) \
		$(usex ipv6 '' --disable-ipv6) \
		$(usex rtc '' --disable-rtc) \
		${CHRONY_EDITLINE} \
		${EXTRA_ECONF} \
		--docdir=/usr/share/doc/${PF} \
		--infodir=/usr/share/info \
		--mandir=/usr/share/man \
		--prefix=/usr \
		--sysconfdir=/etc/chrony \
		--without-nss \
		--without-tomcrypt
	"

	# print the ./configure call to aid in future debugging
	einfo ${CHRONY_CONFIGURE}
	sh ${CHRONY_CONFIGURE} || die
}

src_compile() {
	emake all docs
}

src_install() {
	default
	rm "${D}"/usr/share/doc/${PF}/COPYING || die
	doinfo chrony.info*

	newinitd "${FILESDIR}"/chronyd.init chronyd
	newconfd "${FILESDIR}"/chronyd.conf chronyd

	insinto /etc/${PN}
	newins examples/chrony.conf.example chrony.conf
	newins examples/chrony.keys.example chrony.keys

	keepdir /var/{lib,log}/chrony

	insinto /etc/logrotate.d
	newins "${FILESDIR}"/chrony.logrotate chrony

	systemd_newunit "${FILESDIR}"/chronyd.service-r2 chronyd.service
	systemd_enable_ntpunit 50-chrony chronyd.service
}
