# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4

MY_P=lib${P}

DESCRIPTION="A tool and library for extracting cabs from executable installers"
HOMEPAGE="https://sourceforge.net/projects/synce/"
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
