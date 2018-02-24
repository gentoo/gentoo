# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=MIYAGAWA
DIST_VERSION=0.60
inherit perl-module

DESCRIPTION="Software Release Tool"

SLOT="0"
KEYWORDS="amd64 ~ppc ~x86"
IUSE=""

PATCHES=( "${FILESDIR}/${PN}-0.60-version-test.patch" )

pkg_postinst() {
	elog "Please note that ShipIt does not depend on any specific VCS."
	elog "You must install a supported VCS (CVS, SVN, SVK, GIT, HG) for use."
}
