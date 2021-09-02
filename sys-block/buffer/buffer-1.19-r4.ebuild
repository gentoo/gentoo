# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit flag-o-matic toolchain-funcs

DESCRIPTION="A tapedrive tool for speeding up reading from and writing to tape"
HOMEPAGE="http://www.microwerks.net/~hugo/"

DEBIAN_PR=12
DEBIAN_P="${PN}_${PV}"
DEBIAN_PATCH="${PN}_${PV}-${DEBIAN_PR}.debian.tar.xz"
# We do NOT rename the Debian .orig.tar.gz file at this point
# Because Gentoo shipped a very slightly DIFFERENT buffer-1.19.tgz than Debian!
# Enough to make the debian patchset not apply directly. Debian patchset
# contains the same changes plus more fixes.
SRC_URI="
	mirror://debian/pool/main/b/${PN}/${DEBIAN_P}.orig.tar.gz
	mirror://debian/pool/main/b/${PN}/${DEBIAN_PATCH}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~ppc ~sparc ~x86"

src_prepare() {
	local f
	for f in $(<"${WORKDIR}"/debian/patches/series) ; do
		p="${WORKDIR}"/debian/patches/${f}.patch
		ln -sf "${f}" "${p}" || die
		einfo ${p}
		eapply -p1 "${p}" || die
	done

	cd "${S}" || die
	emake clean
	eapply_user
}

src_compile() {
	append-lfs-flags
	emake CC="$(tc-getCC)" CFLAGS="${CFLAGS}"
}

src_install() {
	dobin buffer
	dodoc README
	newman buffer.man buffer.1
}
