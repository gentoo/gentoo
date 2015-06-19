# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-text/fbreader/fbreader-0.99.4-r1.ebuild,v 1.5 2014/08/06 07:09:31 patrick Exp $

EAPI=5

inherit eutils multilib

DESCRIPTION="E-Book Reader. Supports many e-book formats"
HOMEPAGE="http://www.fbreader.org/"
SRC_URI="http://www.fbreader.org/files/desktop/${PN}-sources-${PV}.tgz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~arm ~ppc x86"
IUSE="debug"

RDEPEND="
	app-arch/bzip2
	dev-libs/expat
	dev-libs/liblinebreak
	dev-libs/fribidi
	dev-db/sqlite
	net-misc/curl
	sys-libs/zlib
	dev-qt/qtcore:4
	dev-qt/qtgui:4
"
DEPEND="${RDEPEND}
	virtual/pkgconfig
"

src_prepare() {
	# Still use linebreak instead of new unibreak
	sed -e "s:-lunibreak:-llinebreak:" \
		-i makefiles/config.mk zlibrary/text/Makefile || die "fixing libunibreak failed"

	# Let portage decide about the compiler
	sed -e "/^CC = /d" \
		-i makefiles/arch/desktop.mk || die "removing CC line failed"

	# let portage strip the binary
	sed -e '/@strip/d' \
		-i fbreader/desktop/Makefile || die

	# Respect *FLAGS
	sed -e "s/^CFLAGS = -pipe/CFLAGS +=/" \
		-i makefiles/arch/desktop.mk || die "CFLAGS sed failed"
	sed -e "/^	CFLAGS +=/ d" \
		-i makefiles/config.mk || die "CFLAGS sed failed"
	sed -e "/^	LDFLAGS += -s$/ d" \
		-i makefiles/config.mk || die "sed failed"
	sed -e "/^LDFLAGS =$/ d" \
		-i makefiles/arch/desktop.mk || die "sed failed"

	echo "TARGET_ARCH = desktop" > makefiles/target.mk
	echo "LIBDIR = /usr/$(get_libdir)" >> makefiles/target.mk

	echo "UI_TYPE = qt4" >> makefiles/target.mk
	sed -e 's:MOC = moc-qt4:MOC = /usr/bin/moc:' \
		-i makefiles/arch/desktop.mk || die "updating desktop.mk failed"

	if use debug; then
		echo "TARGET_STATUS = debug" >> makefiles/target.mk
	else
		echo "TARGET_STATUS = release" >> makefiles/target.mk
	fi

	# bug #452636
	epatch "${FILESDIR}"/${P}.patch
}

src_install() {
	default
	dosym /usr/bin/FBReader /usr/bin/fbreader
}
