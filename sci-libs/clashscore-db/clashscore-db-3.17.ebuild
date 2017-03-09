# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

DESCRIPTION="Clashscore-db for clashlist"
HOMEPAGE="http://kinemage.biochem.duke.edu/"
SRC_URI="mirror://gentoo/molprobity-${PV}.tgz"

SLOT="0"
LICENSE="richardson"
KEYWORDS="amd64 x86 ~amd64-linux ~x86-linux"
IUSE=""

RESTRICT="binchecks strip"

S="${WORKDIR}"

src_install() {
	insinto /usr/share/clashscore
	doins molprobity3/lib/clashscore.db.tab
}
