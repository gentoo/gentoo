# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# we do not use versions in boostrap package, just slot number.
# and bump revisions if needed. this package is one-time use and gets depcleaned.

PPC64_TAR="17.0.1_p12" # this is big-endian only. on ppc64le we have openjdk-bin
#X86_TAR="" # adoptium/temurin does not provide one.

DESCRIPTION="Prebuilt Java JDK binaries for uncommon CPUs or libcs"
HOMEPAGE="https://openjdk.java.net"
#https://dev.gentoo.org/~arthurzam/distfiles/dev-java/openjdk/openjdk-bootstrap-17.0.1_p12-ppc64.tar.xz
SRC_URI="
	ppc64? ( https://dev.gentoo.org/~arthurzam/distfiles/dev-java/${PN%-bootstrap}/${PN}-${PPC64_TAR}-ppc64.tar.xz )
"
#x86? ( https://dev.gentoo.org/~arthurzam/distfiles/dev-java/${PN}/${PN}-bootstrap-${X86_TAR}-x86.tar.xz )

LICENSE="GPL-2-with-classpath-exception"
SLOT="${PV}"
KEYWORDS="-* ~ppc64"

RESTRICT="preserve-libs splitdebug strip"
QA_PREBUILT="*"
QA_SONAME="*"

S="${WORKDIR}"

src_configure() { : ; }

src_compile() { : ; }

src_install() {
	local dest="/opt/${PN}/${SLOT}"
	local ddest="${ED}/${dest#/}"

	dodir "${dest}"
	cp -pPR */* "${ddest}" || die
}
