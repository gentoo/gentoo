# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Virtual Router Redundancy Protocol Daemon"
HOMEPAGE="http://numsys.eu/vrrp_art.php"
SRC_URI="https://github.com/fredbcode/Vrrpd/archive/v${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/Vrrpd-${PV}"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86"

PATCHES=( "${FILESDIR}"/vrrpd-1.9-rollup.patch )

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
	dodoc FAQ Changes TODO scott_example doc/draft-ietf-vrrp-spec-v2-05.txt doc/rfc2338.txt.vrrp doc/draft-jou-duplicate-ip-address-02.txt doc/principe-Vrrp1.jpg doc/principe-Vrrp2.jpg README.md
}
