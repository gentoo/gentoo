# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Clashscore-db for clashlist"
HOMEPAGE="http://kinemage.biochem.duke.edu/"
SRC_URI="mirror://gentoo/molprobity-${PV}.tgz"
S="${WORKDIR}"

LICENSE="richardson"
SLOT="0"
KEYWORDS="amd64 ~x86"

RESTRICT="binchecks strip"

src_install() {
	insinto /usr/share/clashscore
	doins molprobity3/lib/clashscore.db.tab
}
