# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="look up USE flag descriptions fast"
HOMEPAGE="https://www.xs4all.nl/~rooversj/gentoo"
SRC_URI="https://www.xs4all.nl/~rooversj/gentoo/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 arm ~arm64 hppa ppc ppc64 sparc x86"
IUSE=""

S=${WORKDIR}

src_install() {
	dobin ${PN}
	doman ${PN}.1
	dodoc ChangeLog
}
