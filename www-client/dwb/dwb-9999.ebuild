# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit git-r3 toolchain-funcs

EGIT_REPO_URI="https://bitbucket.org/portix/dwb.git"

DESCRIPTION="Dynamic web browser based on WebKit and GTK+"
HOMEPAGE="http://portix.bitbucket.org/dwb/"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS=""
IUSE="examples gtk3 libsecret"

RDEPEND="
	>=net-libs/libsoup-2.38:2.4
	dev-libs/json-c
	net-libs/gnutls
	!gtk3? (
		>=net-libs/webkit-gtk-1.8.0:2
		x11-libs/gtk+:2
	)
	gtk3? (
		>=net-libs/webkit-gtk-1.8.0:3
		x11-libs/gtk+:3
	)
	libsecret? ( app-crypt/libsecret )
"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

src_prepare() {
	sed -i "/^CFLAGS += -\(pipe\|g\|O2\)/d" config.mk || die
}

src_compile() {
	local myconf
	use gtk3 && myconf+=" GTK=3"
	! use libsecret && myconf+=" USE_LIB_SECRET=0"

	emake CC="$(tc-getCC)" ${myconf}
}

src_install() {
	default

	if use examples ; then
		dodoc -r examples
		docompress -x /usr/share/doc/${PF}/examples
	fi
}
