# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Decodes MS-TNEF MIME attachments"
HOMEPAGE="https://github.com/verdammelt/tnef/"
SRC_URI="https://github.com/verdammelt/tnef/releases/download/${PV}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~hppa ~ppc ~ppc64 ~sparc ~x86"

src_test() {
	emake -j1 check
}
