# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=0

inherit eutils

DESCRIPTION="Persistent IRC bouncer with multi-client support - a fork of muh"
HOMEPAGE="http://miau.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.bz2"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc x86"
IUSE="debug ipv6"

DEPEND=""
RDEPEND="${DEPEND}"

pkg_setup() {
	if use ipv6; then
		echo
		ewarn "Enabling the ipv6 useflag will disable ipv4 entirely. Press"
		ewarn "Ctrl+C now if you don't want this."
		echo
		ebeep 5
	fi
}

src_compile() {
	# --disable-debug seems to actually enabled it, using if use rather than
	# use_enable to get around it.
	if use debug; then
		myconf="--enable-debug"
	fi
	econf \
		--enable-dccbounce \
		--enable-automode \
		--enable-releasenick \
		--enable-ctcp-replies \
		--enable-mkpasswd \
		--enable-uptime \
		--enable-chanlog \
		--enable-privlog \
		--enable-onconnect \
		--enable-empty-awaymsg \
		$(use_enable ipv6) \
		${myconf} \
		$(use_enable debug enduserdebug) \
		$(use_enable debug pingstat) \
		$(use_enable debug dumpstatus) \
		|| die "econf failed."
	emake || die "emake failed."
}

src_install() {
	emake install DESTDIR="${D}" || die "emake install failed."
	dodoc AUTHORS ChangeLog TODO README || die "dodoc failed."

	mv "${D}/usr/share/doc/miau/examples/miaurc" \
		"${D}/usr/share/doc/${PF}/miaurc.sample"
	rm -rf "${D}/usr/share/doc/miau"
}

pkg_postinst() {
	echo
	elog "You'll need to configure miau before running it."
	elog "Put your config in ~/.miau/miaurc"
	elog "You can use the sample config is in /usr/share/doc/${PF}/miaurc.sample"
	elog "For more information, see the documentation."
	echo
}
