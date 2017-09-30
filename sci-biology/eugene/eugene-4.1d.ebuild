# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit autotools

DESCRIPTION="Prokaryotic and Eukaryotic gene predictor"
HOMEPAGE="http://eugene.toulouse.inra.fr/"
SRC_URI="https://mulcyber.toulouse.inra.fr/frs/download.php/1359/${P}.tar.gz"

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

PATCHES=(
	# https://mulcyber.toulouse.inra.fr/tracker/index.php?func=detail&aid=1170
	"${FILESDIR}"/${PN}-3.6-overflow.patch
	"${FILESDIR}"/${PN}-3.6-plugins.patch
	"${FILESDIR}"/${PN}-4.1-format-security.patch
	"${FILESDIR}"/${PN}-4.1d-fix-c++14.patch
	"${FILESDIR}"/${PN}-4.1d-Wformat.patch
)

src_prepare() {
	default
	sed \
		-e '/SUBDIRS/ s/doc//' \
		-e '/INSTALL.*doc/ s/\(.*\)//' \
		-i Makefile.am || die
	eautoreconf
}
