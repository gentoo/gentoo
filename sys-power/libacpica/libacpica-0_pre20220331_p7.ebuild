# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs

DESCRIPTION="ACPICA as a library"
HOMEPAGE="https://salsa.debian.org/hurd-team/libacpica"

if [[ ${PV} == *9999* ]] ; then
	EGIT_REPO_URI="https://salsa.debian.org/hurd-team/libacpica.git"
	inherit git-r3
elif [[ ${PV} == *_pre*_p* ]] ; then
	# These are proper Debian relaeses. libacpica isn't currently
	# part of the Debian archive, so this is the best we can do (no
	# 'orig' tarballs).
	LIBACPICA_PV=0_$(ver_cut 3)-$(ver_cut 5)

	SRC_URI="https://salsa.debian.org/hurd-team/libacpica/-/archive/debian/${LIBACPICA_PV}/libacpica-debian-${LIBACPICA_PV}.tar.bz2"
	S="${WORKDIR}"/${PN}-debian-${LIBACPICA_PV}
else
	# Snapshots
	LIBACPICA_COMMIT="0c3593e27947ef0734a070143caadaed28438354"
	SRC_URI="https://salsa.debian.org/hurd-team/libacpica/-/archive/${LIBACPICA_COMMIT}/libacpica-${LIBACPICA_COMMIT}.tar.bz2"
fi

LICENSE="BSD GPL-2+"
SLOT="0"
if [[ ${PV} != *9999* ]] ; then
	KEYWORDS="~amd64 ~x86"
fi

RDEPEND="
	x11-libs/libpciaccess
"
DEPEND="${RDEPEND}"

src_prepare() {
	default

	eapply $(sed -e 's:^:debian/patches/:' debian/patches/series || die)

	sed -i -e 's:ar crs:$(AR) crs:' Makefile || die
}

src_configure() {
	tc-export AR CC
}

src_compile() {
	emake PREFIX="${EPREFIX}"/usr
}

src_install() {
	emake DESTDIR="${D}" PREFIX="${EPREFIX}"/usr libdir="${EPREFIX}/usr/$(get_libdir)" install
}
