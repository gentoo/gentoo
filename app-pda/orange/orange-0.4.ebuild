# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-pda/orange/orange-0.4.ebuild,v 1.8 2014/08/10 18:20:17 slyfox Exp $

EAPI=4

MY_P=lib${P}

DESCRIPTION="A tool and library for extracting cabs from executable installers"
HOMEPAGE="http://sourceforge.net/projects/synce/"
SRC_URI="mirror://sourceforge/synce/${MY_P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="static-libs"

RDEPEND="app-pda/synce-core
	>=app-pda/dynamite-0.1.1
	>=app-arch/unshield-0.6
	sys-apps/file
	sys-libs/zlib"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

S=${WORKDIR}/${MY_P}

DOCS="ChangeLog TODO"

src_configure() {
	econf $(use_enable static-libs static)
}

src_install() {
	default
	find "${ED}" -name '*.la' -exec rm -f {} +
}
