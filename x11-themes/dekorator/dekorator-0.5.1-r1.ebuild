# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-themes/dekorator/dekorator-0.5.1-r1.ebuild,v 1.3 2014/06/17 14:16:43 kensington Exp $

EAPI=5

inherit kde4-base

DESCRIPTION="A window decoration engine for KDE"
HOMEPAGE="http://www.kde-look.org/content/show.php/Nitrogen?content=87921"
SRC_URI="http://www.kde-look.org/CONTENT/content-files/87921-${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="4"
KEYWORDS="amd64 x86"
IUSE="debug"

DEPEND="
	$(add_kdebase_dep kwin)
	media-libs/qimageblitz
"
RDEPEND="${DEPEND}"

DOCS=( AUTHORS ChangeLog CHANGELOG.original README README.original TODO )
