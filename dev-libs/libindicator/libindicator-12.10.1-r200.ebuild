# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/libindicator/libindicator-12.10.1-r200.ebuild,v 1.1 2014/03/15 14:03:58 ssuominen Exp $

EAPI=4
inherit eutils flag-o-matic virtualx

DESCRIPTION="A set of symbols and convience functions that all indicators would like to use"
HOMEPAGE="http://launchpad.net/libindicator"
SRC_URI="http://launchpad.net/${PN}/${PV%.*}/${PV}/+download/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

RDEPEND=">=dev-libs/glib-2.22
	>=x11-libs/gtk+-2.18:2"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	test? ( dev-util/dbus-test-runner )"

src_configure() {
	append-flags -Wno-error

	econf \
		--disable-silent-rules \
		--disable-static \
		--with-gtk=2
}

src_test() {
	Xemake check #391179
}

src_install() {
	emake -j1 DESTDIR="${D}" install
	prune_libtool_files --all

	rm -vf \
		"${ED}"/usr/lib*/libdummy-indicator-* \
		"${ED}"/usr/share/${PN}/*indicator-debugging
}
