# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools

DESCRIPTION="NBTscan is a program for scanning IP networks for NetBIOS name information"
HOMEPAGE="https://github.com/resurrecting-open-source-projects/nbtscan"
SRC_URI="https://github.com/resurrecting-open-source-projects/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc x86 ~amd64-linux ~x86-linux ~ppc-macos"

DOCS=( AUTHORS CONTRIBUTING.md ChangeLog NEWS README.md )

src_prepare() {
	default

	eautoreconf
}
