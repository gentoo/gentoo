# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

KDE_HANDBOOK="true"
inherit kde5

DESCRIPTION="KDE Development Scripts"
KEYWORDS="amd64 ~x86"
IUSE=""

# kdelibs4support - required for kdex.dtd
# kdoctools - to use ECM instead of kdelibs4
DEPEND="
	$(add_frameworks_dep kdelibs4support)
	$(add_frameworks_dep kdoctools)
"
RDEPEND="
	!kde-apps/kde4-l10n
	app-arch/advancecomp
	media-gfx/optipng
	dev-perl/XML-DOM
"

src_prepare() {
	# bug 275069
	sed -ie 's:colorsvn::' CMakeLists.txt || die

	kde5_src_prepare
}
