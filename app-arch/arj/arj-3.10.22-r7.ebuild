# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit autotools

PATCH_LEVEL=15
MY_P="${PN}_${PV}"

DESCRIPTION="Utility for opening arj archives"
HOMEPAGE="http://arj.sourceforge.net/"
SRC_URI="mirror://debian/pool/main/a/arj/${MY_P}.orig.tar.gz
	mirror://debian/pool/main/a/arj/${MY_P}-${PATCH_LEVEL}.debian.tar.xz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~ia64 ~ppc ~ppc64 ~sparc ~x86 ~x86-fbsd ~x86-interix ~amd64-linux ~x86-linux ~ppc-macos ~x86-solaris"
IUSE=""

PATCHES=(
	"${FILESDIR}/${P}-implicit-declarations.patch"
	"${FILESDIR}/${P}-glibc2.10.patch"
	"${WORKDIR}"/debian/patches/
	"${FILESDIR}/${P}-darwin.patch"
	"${FILESDIR}/${P}-interix.patch"
)

DOCS=(
	doc/compile.txt
	doc/debug.txt
	doc/glossary.txt
	doc/rev_hist.txt
	doc/xlation.txt
)

src_prepare() {
	default
	cd gnu || die 'failed to change to the "gnu" directory'
	echo -n "" > stripgcc.lnk || die "failed to disable stripgcc.lnk"

	# This gets rid of the QA warning, but should be fixed upstream...
	mv configure.{in,ac} || die 'failed to move configure.in to configure.ac'

	eautoreconf
}

src_configure() {
	cd gnu || die 'failed to change to the "gnu" directory'
	econf
}
