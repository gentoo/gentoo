# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools

MY_P=${P/_/}

DESCRIPTION="ASCII Image Viewer"
HOMEPAGE="https://aa-project.sourceforge.net/aview/"
SRC_URI="https://downloads.sourceforge.net/aa-project/${MY_P}.tar.gz"
S="${WORKDIR}/${MY_P/rc*/}"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="amd64 ppc x86 ~x64-solaris"

RDEPEND="media-libs/aalib"
DEPEND="${RDEPEND}"

PATCHES=(
	"${FILESDIR}"/${P}-asciiview.patch
	"${FILESDIR}"/${P}-includes.patch
	"${FILESDIR}"/${P}-clang16.patch
)

src_prepare() {
	default

	eautoreconf
}
