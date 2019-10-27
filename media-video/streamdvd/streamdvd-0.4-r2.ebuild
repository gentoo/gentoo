# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit eutils toolchain-funcs

DESCRIPTION="fast tool to backup Video DVDs 'on the fly'"
HOMEPAGE="http://www.badabum.de/streamdvd.html"
SRC_URI="http://www.badabum.de/down/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"

IUSE="X"

DEPEND="media-libs/libdvdread
	media-video/lsdvd
	X? ( dev-perl/Tk
	dev-perl/Tk-JPEG-Lite
	virtual/cdrtools
	>=media-video/dvdauthor-0.6.5
	>=app-cdr/dvd+rw-tools-5.13.4.7.4 )"

S="${WORKDIR}"/StreamDVD-${PV}

src_prepare() {
	use X && eapply "${FILESDIR}"/${P}.patch

	eapply "${FILESDIR}"/${P}-makefile.patch
	eapply "${FILESDIR}"/${P}-gcc41.patch
	eapply "${FILESDIR}"/${P}-libdvdread.patch
	eapply "${FILESDIR}"/${P}-gcc43.patch
	eapply "${FILESDIR}"/${P}-gcc44.patch

	eapply_user
}

src_compile() {
	emake CC="$(tc-getCC)" CXX="$(tc-getCXX)" all addon  # compile also optional packages
}

src_install() {
	dobin streamdvd streamanalyze
	newbin lsdvd lsdvd-streamdvd  # patched lsdvd, rename to avoid conflict with media-video/lsdvd
	dodoc README
	newdoc contrib/lsdvd/AUTHORS AUTHORS.lsdvd
	newdoc contrib/lsdvd/README README.lsdvd
	newdoc contrib/StreamAnalyze/README README.streamanalyze
	if use X; then
		eval `perl '-V:installvendorlib'`
		insinto "$installvendorlib/StreamDVD"
		doins Gui/StreamDVD/*.pm
		dobin Gui/StreamDVD.pl
		dosym StreamDVD.pl /usr/bin/streamdvd_gui  # convinience symlink
		newdoc Gui/README README.gui
	fi
}
