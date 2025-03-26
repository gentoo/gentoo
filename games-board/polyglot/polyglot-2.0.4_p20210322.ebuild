# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Protocol adapter to run UCI chess engines under xboard"
HOMEPAGE="http://hgm.nubati.net/"
# Released upstream version + patch created from git repo
MY_P="${PN}-${PV%_p*}"
SRC_URI="http://hgm.nubati.net/releases/${MY_P}.tar.gz
	https://dev.gentoo.org/~ulm/distfiles/${P}.patch.gz"
S="${WORKDIR}/${MY_P}"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~x86"

PATCHES=( "${WORKDIR}"/${P}.patch )
DOCS="AUTHORS ChangeLog TODO" # README* installed by build system

src_compile() {
	emake CFLAGS="-std=gnu17 ${CFLAGS}"
}

src_install() {
	default
	# Remove (badly rendered) plain text copy of the man page
	rm "${ED}/usr/share/doc/${PF}/README" || die
}
