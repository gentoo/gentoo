# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

ECM_HANDBOOK="true"
KFMIN=5.63.0
inherit ecm kde.org

DESCRIPTION="KDE Development Scripts"

LICENSE="GPL-2" # TODO: CHECK
SLOT="5"
KEYWORDS="~amd64 ~arm64 ~x86"
IUSE=""

# kdelibs4support - required for kdex.dtd
# kdoctools - to use ECM instead of kdelibs4
DEPEND="
	>=kde-frameworks/kdelibs4support-${KFMIN}:5
	>=kde-frameworks/kdoctools-${KFMIN}:5
"
RDEPEND="
	app-arch/advancecomp
	media-gfx/optipng
	dev-perl/XML-DOM
"

src_prepare() {
	ecm_src_prepare

	# bug 275069
	sed -e 's:colorsvn::' -i CMakeLists.txt || die
}
