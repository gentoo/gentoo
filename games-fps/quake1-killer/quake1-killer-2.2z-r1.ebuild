# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="The Killer Quake Patch"
HOMEPAGE="http://kqp.horoy.com/"
SRC_URI="http://www.gamers.org/pub/idgames2/quakec/compilations/kqp220z.zip
	mirror://gentoo/kqp220z.zip"
S="${WORKDIR}"

LICENSE="quake1-killer"
SLOT="0"
KEYWORDS="~amd64 ~x86"

BDEPEND="app-arch/unzip"

src_unpack() {
	elog "Unpacking kqp220z.zip to ${PWD}"
	unzip -qoL "${DISTDIR}"/kqp220z.zip || die "unpacking kqp220z.zip failed"
}

src_install() {
	insinto /usr/share/quake1/killer
	doins -r *
}
