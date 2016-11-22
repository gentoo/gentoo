# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

DESCRIPTION="Fast, intelligent, automatic spam detector using Bayesian analysis"
HOMEPAGE="http://spamprobe.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="QPL"
SLOT="0"
KEYWORDS="amd64 ~ppc x86"
IUSE="berkdb gif jpeg png"

RDEPEND="
	berkdb? ( >=sys-libs/db-3.2:* )
	gif? ( media-libs/giflib:= )
	jpeg? ( virtual/jpeg:0 )
	png? ( media-libs/libpng:0= )
"
DEPEND="${RDEPEND}"

PATCHES=(
	"${FILESDIR}"/${PN}-1.4b-gcc43.patch
	"${FILESDIR}"/${P}-libpng14.patch
	"${FILESDIR}"/${P}+db-5.0.patch
	"${FILESDIR}"/${P}-gcc47.patch
	"${FILESDIR}"/${P}-giflib5.patch
)

src_configure() {
	econf \
		$(use_with gif) \
		$(use_with jpeg) \
		$(use_with png)
}

src_install() {
	default
	insinto /usr/share/${PN}/contrib
	doins contrib/*
}
