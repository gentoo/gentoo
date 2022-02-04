# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

COMMIT="45e6b32de708759a4e15181a8e2ad5de55cc78ef"
inherit optfeature

DESCRIPTION="Download manga from buka.cn"
HOMEPAGE="https://gitlab.com/drylemon/buka"
SRC_URI="https://gitlab.com/drylemon/buka/repository/${PV}/archive.tar.gz?ref=${PV} -> ${P}.tar.gz"
S=${WORKDIR}/${P}-${COMMIT}

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="dev-python/beautifulsoup4
	dev-python/requests
	sys-process/parallel
	net-misc/curl
	dev-util/dialog"

src_install() {
	default
	doman "${PN}.1"
	dobin "${PN}" "${PN}-parse"
}

pkg_postinst() {
	optfeature "pdf support" media-gfx/imagemagick
	optfeature "cbz support" app-arch/zip
}
