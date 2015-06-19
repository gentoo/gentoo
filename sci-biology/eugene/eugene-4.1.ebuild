# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-biology/eugene/eugene-4.1.ebuild,v 1.4 2015/03/25 14:07:24 ago Exp $

EAPI=5

inherit autotools eutils

DESCRIPTION="Eukaryotic gene predictor"
HOMEPAGE="http://www.inra.fr/mia/T/EuGene/"
SRC_URI="https://mulcyber.toulouse.inra.fr/frs/download.php/1157/${P}.tar.gz"

LICENSE="Artistic"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

DEPEND="
	media-libs/gd[png]
	media-libs/libpng:0=
	"
RDEPEND="${DEPEND}"

RESTRICT="test"

src_prepare() {
	# https://mulcyber.toulouse.inra.fr/tracker/index.php?func=detail&aid=1170
	epatch \
		"${FILESDIR}"/${PN}-3.6-overflow.patch \
		"${FILESDIR}"/${PN}-3.6-plugins.patch \
		"${FILESDIR}"/${P}-format-security.patch
	sed \
		-e '/SUBDIRS/ s/doc//' \
		-e '/INSTALL.*doc/ s/\(.*\)//' \
		-i Makefile.am || die
	eautoreconf
}
