# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Virtual Router Redundancy Protocol Daemon"
HOMEPAGE="https://gitlab.com/fredbcode/Vrrpd/"
GITLAB_SHA1="4fdb0d95fd6a09a229a31e975b01271f6245ab5b"
SRC_URI="https://gitlab.com/fredbcode/Vrrpd/-/archive/v${PV}/${P}.tar.bz2"

S="${WORKDIR}/Vrrpd-v${PV}-${GITLAB_SHA1}"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86"

src_prepare() {
	default

	# Don't hardcore GCC
	sed -e '/CC=/d' -i Makefile || die

	emake mrproper
}

src_compile() {
	local myemakeargs=(
		DBG_OPT=""
		MACHINEOPT="${CFLAGS}"
		PROF_OPT="${LDFLAGS}"
	)

	emake "${myemakeargs[@]}"
}

src_install() {
	dosbin vrrpd atropos
	doman vrrpd.8
	dodoc FAQ Changes TODO scott_example README.md
	dodoc doc/*
}
