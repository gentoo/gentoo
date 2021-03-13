# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit autotools

DESCRIPTION="enhanced dd with features for forensics and security"
HOMEPAGE="http://dcfldd.sourceforge.net/"
SRC_URI="https://github.com/resurrecting-open-source-projects/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~ppc ~x86"
DOCS=(
	AUTHORS
	CONTRIBUTING.md
	ChangeLog
	NEWS
	README.md
)

src_prepare() {
	default
	eautoreconf
}
