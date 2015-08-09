# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit kde4-base

DESCRIPTION="KDE ftps KIO slave"
HOMEPAGE="http://kde-apps.org/content/show.php/kio-ftps?content=35875"
SRC_URI="http://dev.gentoo.org/~johu/distfiles/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="4"
KEYWORDS="~amd64 ~x86"
IUSE="debug"

# This is just for some app we can use kio-ftps with
RDEPEND="|| (
	$(add_kdeapps_dep konqueror)
	$(add_kdeapps_dep dolphin)
)"

S="${WORKDIR}/${PN}"

src_prepare() {
	# remove all temp files
	rm -rf *~
	# fix linking
	sed -i \
		-e "s:\${KDE4_KDECORE_LIBS}:\${KDE4_KIO_LIBS}:g" \
		CMakeLists.txt || die "sed linking failed"
}
