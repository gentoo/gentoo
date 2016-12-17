# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit eutils

DESCRIPTION="Download manga from buka.cn"
HOMEPAGE="https://gitgud.io/drylemon/buka"
SRC_URI="http://lick.moe/buka/${P}.tar.gz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="sys-process/parallel
	net-misc/curl
	dev-util/dialog"

src_install()
{
	default
	doman ${PN}.1
	dobin ${PN}
}

pkg_postinst()
{
	optfeature "pdf support" media-gfx/imagemagick
	optfeature "cbz support" app-arch/zip
}
