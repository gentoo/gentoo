# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

DESCRIPTION="Convert CD images from bin/cue to iso+wav/cdr"
HOMEPAGE="http://he.fi/bchunk/"
SRC_URI="${HOMEPAGE}${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="amd64 ppc sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos ~x64-macos ~sparc-solaris ~x86-solaris"

DOCS=( "${P}.lsm" "${PN}.spec" README ChangeLog )

src_install() {
	dobin "${PN}"
	doman "${PN}.1"
	einstalldocs
}
