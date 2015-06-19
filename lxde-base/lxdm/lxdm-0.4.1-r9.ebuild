# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/lxde-base/lxdm/lxdm-0.4.1-r9.ebuild,v 1.3 2014/03/03 23:54:43 pacho Exp $

EAPI="2"

WANT_AUTOMAKE="1.12" #493996
inherit eutils autotools systemd

DESCRIPTION="LXDE Display Manager"
HOMEPAGE="http://lxde.org"
SRC_URI="mirror://sourceforge/lxde/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 ~arm ~ppc x86"

IUSE="consolekit debug gtk3 nls pam"

RDEPEND="consolekit? ( sys-auth/consolekit )
	x11-libs/libxcb
	gtk3? ( x11-libs/gtk+:3 )
	!gtk3? ( x11-libs/gtk+:2 )
	nls? ( sys-devel/gettext )
	pam? ( virtual/pam )"
DEPEND="${RDEPEND}
	>=dev-util/intltool-0.40
	virtual/pkgconfig"

src_prepare() {
	# Upstream bug, tarball contains pre-made lxdm.conf
	rm "${S}"/data/lxdm.conf || die

	# There is consolekit
	epatch "${FILESDIR}/${P}-pam_console-disable.patch"
	# Fix null pointer dereference, backported from git
	epatch "${FILESDIR}/${P}-git-fix-null-pointer-deref.patch"

	epatch "${FILESDIR}"/${P}-configure-add-pam.patch

	# 403999
	epatch "${FILESDIR}"/${P}-missing-pam-defines.patch

	# 412025
	epatch "${FILESDIR}"/${P}-event-check.patch

	# 393329 Selinux support
	epatch "${FILESDIR}"/${P}-selinux-support.patch

	# See https://bugs.launchpad.net/ubuntu/+source/lxdm/+bug/922363
	epatch "${FILESDIR}/${P}-fix-pam-100-cpu.patch"

	# Optional Consolekit support. bug #443666
	epatch "${FILESDIR}"/${P}-optional-consolekit.patch

	# 469512
	epatch "${FILESDIR}"/${P}-fix-optional-pam.patch

	# this replaces the bootstrap/autogen script in most packages
	eautoreconf

	# process LINGUAS
	if use nls; then
		einfo "Running intltoolize ..."
		intltoolize --force --copy --automake || die
		strip-linguas -i "${S}/po" || die
	fi
}
src_configure() {
	econf	--enable-password \
		--with-x \
		--with-xconn=xcb \
		$(use_enable consolekit) \
		$(use_enable gtk3) \
		$(use_enable nls) \
		$(use_enable debug) \
		$(use_with pam)
}

src_install() {
	emake DESTDIR="${D}" install || die
	dodoc AUTHORS README TODO || die
	systemd_dounit "${FILESDIR}"/${PN}.service
}

pkg_postinst() {
	echo
	elog "Take into consideration that LXDM is in the early stages of development!"
	echo
}
