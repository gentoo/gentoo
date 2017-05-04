# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit autotools

DESCRIPTION="Decodes MS-TNEF MIME attachments"
HOMEPAGE="https://github.com/verdammelt/tnef/"
SRC_URI="https://github.com/verdammelt/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="amd64 hppa ~ppc ~ppc64 ~sparc x86"

src_prepare() {
	eautoreconf
	eapply_user
}

src_test() {
	emake -j1 check
}
