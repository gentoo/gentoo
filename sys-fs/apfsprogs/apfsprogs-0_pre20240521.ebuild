# Copyright 2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

EGIT_COMMIT="28c0053dcb77efc267b57013702c17007c21d942"
SRC_URI="https://github.com/linux-apfs/apfsprogs/archive/${EGIT_COMMIT}.tar.gz -> ${P}.tar.gz"
S=${WORKDIR}/${PN}-${EGIT_COMMIT}
KEYWORDS="~amd64"
DESCRIPTION="Experimental APFS tools for linux"
HOMEPAGE="https://github.com/linux-apfs/apfsprogs"
LICENSE="GPL-2"
SLOT="0"
APFSPROGS=(apfs-snap apfsck mkapfs)

src_compile() {
	local prog
	emake -C lib || die
	for prog in "${APFSPROGS[@]}"; do
		emake -C "${prog}" || die
	done
}

src_install() {
	local prog
	for prog in "${APFSPROGS[@]}"; do
		emake -C "${prog}" install DESTDIR="${ED}" BINDIR=/usr/bin MANDIR=/usr/share/man/man8
	done
}
