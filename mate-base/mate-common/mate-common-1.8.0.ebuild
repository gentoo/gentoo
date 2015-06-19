# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/mate-base/mate-common/mate-common-1.8.0.ebuild,v 1.4 2014/07/02 09:46:22 pacho Exp $

EAPI="5"

inherit versionator

MATE_BRANCH="$(get_version_component_range 1-2)"

SRC_URI="http://pub.mate-desktop.org/releases/${MATE_BRANCH}/${P}.tar.xz"
DESCRIPTION="Common files for development of MATE packages"
HOMEPAGE="http://mate-desktop.org"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 x86"

src_install() {
	mv doc-build/README README.doc-build \
		|| die "Failed to rename doc-build/README."

	default

	dodoc doc/usage.txt
}
