# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-fs/simple-mtpfs/simple-mtpfs-0.2.ebuild,v 1.2 2015/02/28 17:40:30 ago Exp $

EAPI=5

EGIT_REPO_URI="git://github.com/phatina/${PN}.git"
inherit autotools-utils eutils
[[ ${PV} == 9999 ]] && inherit git-r3

DESCRIPTION="Simple MTP fuse filesystem driver"
HOMEPAGE="https://github.com/phatina/simple-mtpfs"
[[ ${PV} == 9999 ]] || SRC_URI="https://github.com/phatina/${PN}/archive/${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
[[ ${PV} == 9999 ]] || \
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="
	media-libs/libmtp
	>=sys-fs/fuse-2.8
"
DEPEND="${RDEPEND}
	virtual/pkgconfig
"

[[ ${PV} == 9999 ]] || S="${WORKDIR}/${PN}-${P}"

AUTOTOOLS_AUTORECONF=1
