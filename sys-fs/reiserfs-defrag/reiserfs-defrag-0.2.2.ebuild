# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake

DESCRIPTION="Small defragmentation tool for reiserfs"
HOMEPAGE="https://github.com/i-rinat/reiserfs-defrag"
SRC_URI="https://github.com/i-rinat/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"

DEPEND=""
RDEPEND="${DEPEND}"

DOCS=( ChangeLog README.md )

pkg_postinst() {
	ewarn "Defragmentation should be done OFFLINE only! You MUST unmount your reiserfs partition before starting ${PN}"
}
