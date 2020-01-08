# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

DESCRIPTION="Convert CD images from bin/cue to iso+wav/cdr"
HOMEPAGE="http://he.fi/bchunk/"
SRC_URI="http://he.fi/bchunk/${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="amd64 ppc ppc64 sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~x86-solaris"

DOCS=( "${P}.lsm" "${PN}.spec" README ChangeLog )
PATCHES=( "${FILESDIR}/CVE-2017-15953.patch" "${FILESDIR}/CVE-2017-15955.patch" )

src_install() {
	dobin "${PN}"
	doman "${PN}.1"
	einstalldocs
}
