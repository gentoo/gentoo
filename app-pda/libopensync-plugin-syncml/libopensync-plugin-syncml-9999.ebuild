# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-pda/libopensync-plugin-syncml/libopensync-plugin-syncml-9999.ebuild,v 1.5 2011/03/19 06:45:16 dirtyepic Exp $

EAPI="4"

inherit cmake-utils subversion

DESCRIPTION="OpenSync SyncML Plugin"
HOMEPAGE="http://www.opensync.org/"
SRC_URI=""

ESVN_REPO_URI="http://svn.opensync.org/plugins/syncml/trunk"

KEYWORDS="~amd64 ~ppc ~x86"
SLOT="0"
LICENSE="LGPL-2.1"
IUSE="http +obex"

REQUIRED_USE="|| ( http obex )"

RDEPEND="~app-pda/libopensync-${PV}
	~app-pda/libsyncml-${PV}[obex?,http?]
	dev-libs/glib:2
	dev-libs/libxml2"
DEPEND="${RDEPEND}"

RESTRICT="test"

src_configure() {
	DOCS="AUTHORS"

	local mycmakeargs="
		$(cmake-utils_use_enable http HTTP)
		$(cmake-utils_use_enable obex OBEX)"

	cmake-utils_src_configure
}
