# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit autotools

DESCRIPTION="Decodes MS-TNEF MIME attachments"
HOMEPAGE="https://github.com/verdammelt/tnef/"
SRC_URI="https://github.com/verdammelt/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~amd64 ~hppa ~ppc ~ppc64 ~sparc ~x86"

src_prepare() {
	default

	eautoreconf
}

src_test() {
	emake -j1 check
}
