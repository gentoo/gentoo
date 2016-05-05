# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit autotools

DESCRIPTION="a front-end for Oracle program sqlplus with command-line editing"
HOMEPAGE="https://sourceforge.net/projects/gqlplus/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x64-macos"
IUSE=""

DEPEND="sys-libs/readline:*"
RDEPEND="${DEPEND}"

src_prepare() {
	# don't use packaged readline and old version containing it
	rm -Rf readline gqlplus-1.15

	# maintainer can't seem to get versioning right
	sed -i '/^#define VERSION/s/"[^"]\+"/"'"${PV}"'"/' gqlplus.c || die
	sed -i '/^AC_INIT/s/\[[1-9.]\+\]/['"${PV}"']/' configure.ac || die
	eautoreconf
}
