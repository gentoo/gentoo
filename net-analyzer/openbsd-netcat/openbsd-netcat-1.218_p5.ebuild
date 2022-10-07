# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs

MY_PV=$(ver_cut 1-2)
DESCRIPTION="The OpenBSD network swiss army knife"
HOMEPAGE="https://cvsweb.openbsd.org/src/usr.bin/nc/ https://salsa.debian.org/debian/netcat-openbsd"
SRC_URI="
	mirror://debian/pool/main/n/netcat-openbsd/netcat-openbsd_${MY_PV}.orig.tar.gz
	mirror://debian/pool/main/n/netcat-openbsd/netcat-openbsd_${MY_PV}-$(ver_cut 4).debian.tar.xz
"
S="${WORKDIR}"/netcat-openbsd-${MY_PV}

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc ~ppc64 ~riscv ~x86 ~amd64-linux ~x64-macos"

RDEPEND="
	!net-analyzer/netcat
	!net-analyzer/netcat6
	!elibc_Darwin? ( dev-libs/libbsd )
"
BDEPEND="virtual/pkgconfig"

src_prepare() {
	local i
	for i in $(<"${WORKDIR}"/debian/patches/series) ; do
		PATCHES+=( "${WORKDIR}"/debian/patches/${i} )
	done

	if [[ ${CHOST} == *-darwin* ]] ; then
		# This undoes some of the Debian/Linux changes
		PATCHES+=( "${FILESDIR}"/${PN}-1.195-darwin.patch )

		if [[ ${CHOST##*-darwin} -lt 20 ]] ; then
			PATCHES+=( "${FILESDIR}"/${PN}-1.190-darwin13.patch )
		fi
	fi

	if use elibc_musl ; then
		PATCHES+=( "${FILESDIR}"/${PN}-1.105-musl-b64_ntop.patch )
	fi

	default
}

src_compile() {
	emake CC="$(tc-getCC)" CFLAGS="${CFLAGS}" LDFLAGS="${LDFLAGS}"
}

src_install() {
	dobin nc
	doman nc.1

	cd "${WORKDIR}"/debian || die
	newdoc netcat-openbsd.README.Debian README
	dodoc -r examples
}

pkg_postinst() {
	if use kernel_linux ; then
		ewarn "SO_REUSEPORT is introduced in linux 3.9. If your running kernel is older"
		ewarn "and kernel header is newer, nc will not listen correctly. Matching the header"
		ewarn "to the running kernel will do. See bug #490246 for details."
	fi
}
