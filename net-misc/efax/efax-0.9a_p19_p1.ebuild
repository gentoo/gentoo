# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit toolchain-funcs

DESCRIPTION="A simple fax program for single-user systems"
HOMEPAGE="https://www.cce.com/efax/"
SRC_URI="
	mirror://debian/pool/main/${PN:0:1}/${PN}/${PN}_${PV/_p*}.orig.tar.gz
	mirror://debian/pool/main/${PN:0:1}/${PN}/${PN}_${PV/_p*}-$(ver_cut 5).$(ver_cut 7).diff.gz
"

KEYWORDS="amd64 ppc x86"
SLOT="0"
LICENSE="GPL-2"
PATCHES=(
	"${FILESDIR}"/${PN}-0.9a-fax-command.patch
	"${FILESDIR}"/${PN}-0.9a-fno-common.patch
	"${FILESDIR}"/${PN}-0.9a-strip.patch
)
S="${WORKDIR}/${P/_p*}-001114"

src_prepare() {
	eapply "${WORKDIR}"/${PN}_${PV/_p*}-$(ver_cut 5).$(ver_cut 7).diff
	local patch
	for patch in $(< debian/patches/00list); do
		if [[ -f debian/patches/${patch} ]]; then
			eapply debian/patches/${patch}
		elif [[ -f debian/patches/${patch}.dpatch ]]; then
			eapply debian/patches/${patch}.dpatch
		else
			die "Cannot find patch ${patch}"
		fi
	done

	default
}

src_compile() {
	emake CC="$(tc-getCC)" CFLAGS="${CFLAGS}" LDFLAGS="${LDFLAGS}"
}

src_install() {
	dobin efax efix fax
	doman efax.1 efix.1
	newman fax.1 efax-fax.1 # Don't collide with net-dialup/mgetty, bug #429808
	dodoc README
}
