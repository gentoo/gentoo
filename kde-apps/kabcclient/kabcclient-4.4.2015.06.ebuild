# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

KMNAME="kdepim"
KMMODULE="console/${PN}"
KDE_HANDBOOK=optional
inherit kde4-meta

DESCRIPTION="A command line client for accessing the KDE addressbook (noakonadi branch)"
KEYWORDS="amd64 ~ppc x86 ~amd64-linux ~x86-linux"
IUSE="debug"

DEPEND="
	$(add_kdeapps_dep kdepimlibs '' 4.6)
"
RDEPEND="${DEPEND}"

src_install() {
	kde4-meta_src_install

	# work around NULL DT_RPATH in kabc2mutt
	dosym kabcclient ${PREFIX}/bin/kabc2mutt || die "couldn't symlink kabc2mutt to kabcclient"
}
