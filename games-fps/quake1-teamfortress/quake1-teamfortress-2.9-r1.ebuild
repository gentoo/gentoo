# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit edos2unix

DESCRIPTION="The classic Team Fortress Quake World mod"
HOMEPAGE="http://www.planetfortress.com/teamfortress/"
SRC_URI="mirror://gentoo/tf28.zip
	mirror://gentoo/tf29qw.zip"
S="${WORKDIR}"

LICENSE="quake1-teamfortress"
SLOT="0"
KEYWORDS="~amd64 ~x86"

BDEPEND="app-arch/unzip"

src_unpack() {
	elog "Unpacking tf28.zip to ${PWD}"
	unzip -qoL "${DISTDIR}"/tf28.zip || die "unpacking tf28.zip failed"

	cd fortress || die
	elog "Unpacking tf29qw.zip to ${PWD}"
	unzip -qoL "${DISTDIR}"/tf29qw.zip || die "unpacking tf29qw.zip failed"

	edos2unix $(find . -name '*.txt' -o -name '*.cfg' || die)
	mv server.cfg server.example.cfg || die
}

src_install() {
	insinto /usr/share/quake1
	doins -r *
}
