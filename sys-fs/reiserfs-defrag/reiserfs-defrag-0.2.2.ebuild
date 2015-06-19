# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-fs/reiserfs-defrag/reiserfs-defrag-0.2.2.ebuild,v 1.1 2013/10/24 18:00:20 pinkbyte Exp $

EAPI=5

inherit cmake-utils

DESCRIPTION="Small defragmentation tool for reiserfs"
HOMEPAGE="https://github.com/i-rinat/reiserfs-defrag"
SRC_URI="https://github.com/i-rinat/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"
IUSE="debug"

DEPEND=""
RDEPEND="${DEPEND}"

DOCS=( ChangeLog README.md )

pkg_postinst() {
	ewarn "Defragmentation should be done OFFLINE only! You MUST unmount your reiserfs partition before starting ${PN}"
}
