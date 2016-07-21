# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
VALA_MIN_API_VERSION="0.16"
inherit eutils vala

DESCRIPTION="UPower/UDisks Event, a lightweight desktop-independent power and disk manager"
HOMEPAGE="http://elentir.sleipnir.fr/ http://git.sleipnir.fr/uevt/"
SRC_URI="http://ftp.sleipnir.fr/${PN}/${P}.tar.bz2"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

COMMON_DEPEND=">=dev-libs/glib-2.28
	x11-libs/gtk+:2
	>=x11-libs/libnotify-0.7"
# Prefer sys-power/upower-pm-utils because there is no Hibernate/Suspend otherwise
RDEPEND="${COMMON_DEPEND}
	>=sys-fs/udisks-1.0.5:0
	|| ( sys-power/upower-pm-utils >=sys-power/upower-0.9.23 )"
DEPEND="${COMMON_DEPEND}
	$(vala_depend)
	dev-util/intltool
	sys-devel/gettext
	virtual/pkgconfig"

DOCS="AUTHORS ChangeLog README"

pkg_setup() {
	export VALAC="$(type -P valac-${UEVT_VALA_VERSION})"
}

src_prepare() {
	# http://git.sleipnir.fr/uevt/commit/?id=69d2f45e234190fbfb37745ea05ab88547a3de96
	epatch \
		"${FILESDIR}"/${P}-support_for_more_than_one_CPU.patch \
		"${FILESDIR}"/${P}-vala-0.24.patch

	# See https://bugs.gentoo.org/ wrt #428438
	echo src/configurator.c >> po/POTFILES.skip
	echo src/power-infos.c >> po/POTFILES.skip

	vala_src_prepare
}

pkg_postinst() {
	has_version '>=sys-power/upower-0.99.0' && \
		ewarn "This version of UEvt doesn't support Hibernate/Suspend with UPower >= 0.99.0"
}
