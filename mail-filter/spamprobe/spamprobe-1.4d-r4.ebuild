# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs flag-o-matic

DESCRIPTION="Fast, intelligent, automatic spam detector using Bayesian analysis"
HOMEPAGE="https://spamprobe.sourceforge.net/"
SRC_URI="https://downloads.sourceforge.net/${PN}/${P}.tar.gz"

LICENSE="QPL-1.0"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="jpeg png"

RDEPEND="
	jpeg? ( media-libs/libjpeg-turbo:= )
	png? ( media-libs/libpng:0= )
"
DEPEND="${RDEPEND}"

PATCHES=(
	"${FILESDIR}"/${PN}-1.4b-gcc43.patch
	"${FILESDIR}"/${P}-libpng14.patch
	"${FILESDIR}"/${P}-gcc47.patch
	"${FILESDIR}"/${P}-gcc11-const-comp.patch
	"${FILESDIR}"/${P}-missing-includes.patch
)

src_configure() {
	local myconf=(
		# https://bugs.gentoo.org/948225
		--without-db
		# https://bugs.gentoo.org/933167
		--without-gif
		$(use_with jpeg)
		$(use_with png)
	)

	append-cxxflags -std=c++11
	econf "${myconf[@]}"
}

src_compile() {
	emake AR="$(tc-getAR)"
}

src_install() {
	default

	insinto /usr/share/${PN}/contrib
	doins contrib/*
}
