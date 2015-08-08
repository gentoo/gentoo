# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit eutils udev

DESCRIPTION="Library implementation for listing vpds"
HOMEPAGE="http://sourceforge.net/projects/linux-diag/"
SRC_URI="http://sourceforge.net/projects/linux-diag/files/libvpd/${PV}/libvpd-${PV}.tar.gz"

LICENSE="IBM"
SLOT="0"
KEYWORDS="~ppc ~ppc64"
IUSE="static-libs"

DEPEND="
	>=dev-db/sqlite-3.7.8
	sys-libs/zlib
"
RDEPEND="${DEPEND}"

src_configure() {
	# sysconfdir is used only to establish where the udev rules file should go
	# unfortunately it also adds the subdirs on its own so we strip it down to
	# dirname
	econf \
		$(use_enable static-libs static) \
		--sysconfdir="$( dirname $(get_udevdir) )"
}

src_install(){
	emake DESTDIR="${D}" install
	prune_libtool_files

}
