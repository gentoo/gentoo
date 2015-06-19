# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-misc/smb4k/smb4k-1.2.0.ebuild,v 1.4 2015/05/13 09:31:29 ago Exp $

EAPI=5

CMAKE_IN_SOURCE_BUILD="true"
DECLARATIVE_REQUIRED="always"
KDE_LINGUAS="bg bs ca ca@valencia cs da de en_GB eo es et fi fr ga gl hu is it
ja ko lt mai mr nb nds nl pl pt pt_BR ro ru sk sv tr ug uk zh_CN zh_TW"
KDE_HANDBOOK="optional"
KDE_DOC_DIRS="doc doc-translations/%lingua_${PN}"
inherit kde4-base

DESCRIPTION="The advanced network neighborhood browser for KDE"
HOMEPAGE="http://sourceforge.net/projects/smb4k/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.xz"

LICENSE="GPL-2"
SLOT="4"
KEYWORDS="amd64 ~ppc x86"
IUSE="debug"

RDEPEND=">=net-fs/samba-3.4.2[cups]"
DEPEND="${RDEPEND}
	sys-devel/gettext
"

DOCS=( AUTHORS BUGS ChangeLog README )
