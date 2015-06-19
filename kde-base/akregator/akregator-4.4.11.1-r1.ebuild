# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/akregator/akregator-4.4.11.1-r1.ebuild,v 1.12 2014/08/05 18:17:07 mrueg Exp $

EAPI=5

KMNAME="kdepim"
inherit kde4-meta

DESCRIPTION="KDE news feed aggregator"
HOMEPAGE="http://www.kde.org/applications/internet/akregator"
KEYWORDS="amd64 ppc x86 ~amd64-linux ~x86-linux"
IUSE="debug +handbook"

DEPEND="
	$(add_kdebase_dep kdelibs '' 4.6)
	$(add_kdebase_dep kdepimlibs '' 4.6)
	$(add_kdebase_dep libkdepim)
"
RDEPEND="${DEPEND}"

PATCHES=(
	"${FILESDIR}/${PN}"-4.4.11.1-revert.patch
)

KMLOADLIBS="libkdepim"
