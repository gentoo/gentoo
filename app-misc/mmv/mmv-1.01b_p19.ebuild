# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit flag-o-matic toolchain-funcs

DEB_PATCH_VER=${PV#*_p}
MY_VER=${PV%_p*}

DESCRIPTION="Move/copy/append/link multiple files according to a set of wildcard patterns"
HOMEPAGE="https://packages.debian.org/unstable/utils/mmv"
SRC_URI="
	mirror://debian/pool/main/m/mmv/${PN}_${MY_VER}.orig.tar.gz
	mirror://debian/pool/main/m/mmv/${PN}_${MY_VER}-${DEB_PATCH_VER}.debian.tar.xz"

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm64 ppc ~riscv x86 ~amd64-linux ~x86-linux ~ppc-macos"

S="${WORKDIR}/${PN}-${MY_VER}.orig"

src_prepare() {
	default
	rm "${WORKDIR}"/debian/patches/better-diagnostics-for-directories-584850.diff \
		|| die #661492
	eapply "${WORKDIR}"/debian/patches/*.diff
}

src_compile() {
	# i wonder how this works on other platforms if CFLAGS from makefile are
	# overridden, see bug #218082
	[[ ${CHOST} == *-interix* ]] && append-flags -DIS_SYSV -DHAS_RENAME -DHAS_DIRENT
	[[ ${CHOST} == *-interix* ]] || append-lfs-flags

	emake CC="$(tc-getCC)" CFLAGS="${CFLAGS}" LDFLAGS="${LDFLAGS}"
}

src_install() {
	dobin "${PN}"
	dosym "${PN}" /usr/bin/mcp
	dosym "${PN}" /usr/bin/mln
	dosym "${PN}" /usr/bin/mad

	doman "${PN}.1"
	newman "${PN}.1" mcp.1
	newman "${PN}.1" mln.1
	newman "${PN}.1" mad.1

	dodoc ANNOUNCE "${WORKDIR}"/debian/{changelog,control}
}
