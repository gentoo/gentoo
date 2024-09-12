# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

ECM_HANDBOOK="optional"
KFMIN=6.5.0
inherit ecm gear.kde.org

DESCRIPTION="KDE Development Scripts"

LICENSE="GPL-2" # TODO: CHECK
SLOT="6"
KEYWORDS="~amd64 ~arm64 ~riscv ~x86"
IUSE=""

RDEPEND="
	app-arch/advancecomp
	dev-perl/XML-DOM
	media-gfx/optipng
"

src_prepare() {
	ecm_src_prepare

	# bug 275069
	sed -e 's:colorsvn::' -i CMakeLists.txt || die
}
