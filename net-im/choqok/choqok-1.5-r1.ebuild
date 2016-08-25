# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

KDE_LINGUAS="bg bs ca ca@valencia cs da de el en_GB eo es et fa fi fr ga gl
hr hu is it ja km lt mr ms nb nds nl pa pl pt pt_BR ro ru sk sl sq sv tr ug
uk zh_CN zh_TW"
KDE_HANDBOOK="optional"
WEBKIT_REQUIRED="optional"
inherit kde4-base

DESCRIPTION="Free/Open Source micro-blogging client by KDE"
HOMEPAGE="http://choqok.gnufolks.org/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.xz"

KEYWORDS="~amd64 ~x86"
LICENSE="GPL-2+"
SLOT="4"
IUSE="ayatana debug telepathy"

RDEPEND="
	dev-libs/libattica
	dev-libs/qjson
	>=dev-libs/qoauth-1.0.1:0
	ayatana? ( dev-libs/libindicate-qt )
	telepathy? ( net-libs/telepathy-qt[qt4] )
"
DEPEND="${RDEPEND}
	app-arch/xz-utils
	sys-devel/gettext
"

DOCS=( AUTHORS README TODO changelog )

PATCHES=(
	"${FILESDIR}/${P}-kdewebkit-optional.patch"
	"${FILESDIR}/${P}-telepathy-optional.patch"
)

src_configure(){
	local mycmakeargs=(
		-DQTINDICATE_DISABLE=$(usex "!ayatana")
		$(cmake-utils_use_find_package telepathy TelepathyQt4)
		-DWITH_KDEWEBKIT=$(usex webkit)
	)
	kde4-base_src_configure
}
