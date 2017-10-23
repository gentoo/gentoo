# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

myCommit="f700dd2b6af1f0c93b6b1eb1d75e658783f848e2"

DESCRIPTION=" Helper utilities for debugging Compiz"
HOMEPAGE="https://github.com/compiz-reloaded"
SRC_URI="https://github.com/compiz-reloaded/${PN}/archive/${myCommit}.zip -> ${P}-${myCommit}.zip"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
		>=dev-lang/python-3:*
		>=x11-wm/compiz-0.8[dbus]
		<x11-wm/compiz-0.9[dbus]
"
DEPEND="${RDEPEND}"

S="${WORKDIR}/${PN}-${myCommit}"

src_install() {
	dodoc README.md
	rm README.md
	dobin *
}
