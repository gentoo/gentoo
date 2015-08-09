# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="4"

inherit autotools eutils

MY_P="${P/g/G}"

DESCRIPTION="CDB binding for Gauche"
HOMEPAGE="http://sourceforge.jp/projects/gauche/"
SRC_URI="mirror://sourceforge.jp/gauche/8407/${MY_P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="ia64 x86"
IUSE=""

RDEPEND="dev-scheme/gauche
	dev-db/tinycdb"
DEPEND="${RDEPEND}"
S="${WORKDIR}/${MY_P}"

src_prepare() {
	epatch "${FILESDIR}"/${P}-gauche-package.diff
	epatch "${FILESDIR}"/${P}-undefined-reference.diff
	eautoreconf
}
