# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit cmake-utils subversion

DESCRIPTION="Implementation of the SyncML protocol"
HOMEPAGE="http://libsyncml.opensync.org/"
SRC_URI=""

ESVN_REPO_URI="http://svn.opensync.org/libsyncml/trunk"

KEYWORDS="~amd64 ~ppc ~x86"
SLOT="0"
LICENSE="LGPL-2.1"
IUSE="+debug doc http +obex test"

# bluetooth and obex merged because bluetooth support in obex backend is
# automagic, bug #285040
# libsoup:2.2 is forced off to avoid automagic
RDEPEND=">=dev-libs/glib-2.12
	>=dev-libs/libwbxml-0.11.0
	dev-libs/libxml2
	http? ( net-libs/libsoup:2.4 )
	obex? (
		net-wireless/bluez
		>=dev-libs/openobex-1.1[bluetooth] )"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	doc? ( app-doc/doxygen )
	test? ( >=dev-libs/check-0.9.7 )"

REQUIRED_USE="|| ( http obex )"

DOCS="AUTHORS CODING ChangeLog RELEASE"

src_prepare() {
	# https://bugs.gentoo.org/425738
	sed -i \
		-e '/include/s:wbxml.h:wbxml/&:' \
		libsyncml/parser/sml_wbxml_internals.h tests/mobiles/obex_mobile_ds_client.c || die
}

src_configure() {
	local mycmakeargs=(
		-DHAVE_LIBSOUP22=OFF
		$(cmake-utils_use_build doc DOCUMENTATION)
		$(cmake-utils_use_enable debug TRACE)
		$(cmake-utils_use_enable http HTTP)
		$(cmake-utils_use_enable obex OBEX)
		$(cmake-utils_use_enable obex BLUETOOTH)
		$(cmake-utils_use_enable test UNIT_TEST)
	)

	cmake-utils_src_configure
}
