# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DECLARATIVE_REQUIRED="always"
KDE_LINGUAS="bg bs ca ca@valencia cs da de en_GB eo es et fi fr ga gl hu is it
ja ko lt mai mr nb nds nl nn pl pt pt_BR ro ru sk sv tr ug uk zh_CN zh_TW"
KDE_HANDBOOK="optional"
KDE_DOC_DIRS="doc doc-translations/%lingua_${PN}"
inherit kde4-base

DESCRIPTION="The advanced network neighborhood browser by KDE"
HOMEPAGE="https://sourceforge.net/projects/smb4k/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.xz"

LICENSE="GPL-2"
SLOT="4"
KEYWORDS="amd64 x86"
IUSE="debug"

RDEPEND="net-fs/samba[cups]"
DEPEND="${RDEPEND}
	sys-devel/gettext
"

DOCS=( AUTHORS BUGS ChangeLog README )

PATCHES=( "${FILESDIR}/${P}-CVE-2017-8849.patch" )
