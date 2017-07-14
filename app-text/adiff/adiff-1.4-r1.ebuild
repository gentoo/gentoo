# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="Wordise diff"
HOMEPAGE="https://wiki.gentoo.org/wiki/No_homepage"
SRC_URI="mirror://gentoo/${P}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~ia64 ~ppc64 ~x86 ~amd64-linux ~x86-linux ~ppc-macos"

DEPEND="
	dev-lang/perl
	!app-arch/atool"

RDEPEND="
	${DEPEND}
	sys-apps/diffutils"

S="${WORKDIR}"

src_unpack() {
	:; # Nothing to unpack.
}

src_compile() {
	local _p2m=(
	    --release=${PV}
		--center="${HOMEPAGE}"
		--date="2007-12-11"
		"${DISTDIR}"/${P}
		${PN}.1
	)

	pod2man "${_p2m[@]}" || die
}

src_install() {
	newbin "${DISTDIR}/${P}" "${PN}"
	doman "${PN}.1"
}
