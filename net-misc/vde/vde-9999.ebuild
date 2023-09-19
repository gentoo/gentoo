# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools flag-o-matic

if [[ ${PV} == 9999 ]]; then
	EGIT_REPO_URI="https://github.com/virtualsquare/vde-2"
	inherit git-r3
elif [[ ${PV} == *_p* ]]; then
	MY_COMMIT="c7b36a57831a9067c8619c3e17a03e595623b3eb"
	SRC_URI="https://github.com/virtualsquare/vde-2/archive/${MY_COMMIT}.tar.gz -> ${P}.tar.gz"
	S="${WORKDIR}/vde-2-${COMMIT}"
else
	MY_P="${PN}2-${PV}"
	SRC_URI="https://github.com/virtualsquare/vde-2/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"
	S="${WORKDIR}/vde-2-${PV}"
fi

DESCRIPTION="Virtual distributed ethernet emulator for emulators like qemu, bochs, and uml"
HOMEPAGE="https://virtualsquare.org/"

LICENSE="GPL-2"
SLOT="0"
if [[ ${PV} != 9999 ]] ; then
	KEYWORDS="~amd64 ~arm64 ~loong ~ppc ~ppc64 ~riscv ~x86"
fi
IUSE="pcap selinux static-libs"

DEPEND="pcap? ( net-libs/libpcap )"
RDEPEND="
	${DEPEND}
	acct-group/qemu
	selinux? ( sec-policy/selinux-vde )
"

src_prepare() {
	default

	eautoreconf
}

src_configure() {
	filter-flags -O0 -Os

	local myeconfargs=(
		# Upstream switched to wolfssl, so no SSL support for now
		--disable-cryptcab
		$(use_enable pcap)
		$(use_enable static-libs static)
	)

	econf "${myeconfargs[@]}"
}

src_install() {
	default

	find "${ED}" -name '*.la' -type f -delete || die

	newinitd "${FILESDIR}"/vde.init-r1 vde
	newconfd "${FILESDIR}"/vde.conf-r1 vde
}

pkg_postinst() {
	einfo "To start vde automatically, add it to the default runlevel:"
	einfo "# rc-update add vde default"
	einfo "You need to setup tap0 in ${EROOT}/etc/conf.d/net"
	einfo "To use it as an user, be sure to set a group in ${EROOT}/etc/conf.d/vde"
}
