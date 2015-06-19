# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-apps/systemd-ui/systemd-ui-9999.ebuild,v 1.6 2014/10/12 04:34:41 zmedico Exp $

EAPI=4

#if LIVE
AUTOTOOLS_AUTORECONF=yes
EGIT_REPO_URI="git://anongit.freedesktop.org/systemd/${PN}
	http://cgit.freedesktop.org/systemd/${PN}/"

inherit git-2
#endif

# Needed per https://bugs.freedesktop.org/show_bug.cgi?id=69643#c5
VALA_MIN_API_VERSION=0.22

inherit autotools-utils systemd vala

DESCRIPTION="System and service manager for Linux"
HOMEPAGE="http://www.freedesktop.org/wiki/Software/systemd"
SRC_URI="http://www.freedesktop.org/software/systemd/${P}.tar.xz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="!sys-apps/systemd[gtk]
	>=dev-libs/glib-2.26
	dev-libs/libgee:0.8
	sys-apps/dbus
	x11-libs/gtk+:3
	>=x11-libs/libnotify-0.7"

DEPEND="${RDEPEND}
	app-arch/xz-utils
	$(vala_depend)"

#if LIVE
SRC_URI=
KEYWORDS=

DEPEND="${DEPEND}
	app-text/docbook-xml-dtd:4.2"
#endif

# Due to vala being broken.
AUTOTOOLS_IN_SOURCE_BUILD=1

src_prepare() {
	# Force the rebuild of .vala sources
	touch src/*.vala || die

	# Fix hardcoded path in .vala.
	sed -i -e "s^/lib/systemd^$(systemd_get_utildir)^g" src/*.vala || die

	autotools-utils_src_prepare
	vala_src_prepare
}
