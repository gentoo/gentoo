# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/kabcclient/kabcclient-4.14.10.ebuild,v 1.1 2015/07/11 11:49:27 johu Exp $

EAPI=5

KDE_HANDBOOK="optional"
KMNAME="kdepim"
EGIT_BRANCH="KDE/4.14"
KMMODULE="console/${PN}"
inherit kde4-meta

DESCRIPTION="A command line client for accessing the KDE addressbook"
KEYWORDS="~amd64 ~arm ~ppc ~ppc64 ~x86 ~amd64-linux ~x86-linux"
IUSE="debug"

DEPEND="
	$(add_kdebase_dep kdepimlibs 'akonadi(+)')
"
RDEPEND="${DEPEND}"

src_install() {
	kde4-meta_src_install

	# work around NULL DT_RPATH in kabc2mutt
	dosym kabcclient ${PREFIX}/bin/kabc2mutt
}
