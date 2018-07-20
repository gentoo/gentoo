# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=4

inherit autotools-utils

DESCRIPTION="A repository commit helper"
HOMEPAGE="https://bitbucket.org/gentoo/repo-commit/"
SRC_URI="https://www.bitbucket.org/gentoo/${PN}/downloads/${P}.tar.bz2"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="
	|| (
		>=sys-apps/portage-2.2.0_alpha86
		( >=sys-apps/portage-2.1.10.30
			<sys-apps/portage-2.2.0_alpha )
		sys-apps/portage-mgorny
		( sys-apps/portage
			app-portage/gentoolkit-dev )
	)"
