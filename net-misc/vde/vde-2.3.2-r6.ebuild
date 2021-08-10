# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

MY_P="${PN}2-${PV}"

DESCRIPTION="Virtual distributed ethernet emulator for emulators like qemu, bochs, and uml"
SRC_URI="mirror://sourceforge/vde/${MY_P}.tar.bz2"
HOMEPAGE="https://virtualsquare.org"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 arm64 ~ppc ppc64 x86"
IUSE="pcap selinux ssl static-libs"

COMMON_DEPS="pcap? ( net-libs/libpcap )
	ssl? ( dev-libs/openssl:0= )
	"
DEPEND="${COMMON_DEPS}"
RDEPEND="${COMMON_DEPS}
	acct-group/qemu
	selinux? ( sec-policy/selinux-vde )"

S="${WORKDIR}/${MY_P}"

PATCHES=(
	"${FILESDIR}/${P}-format-security.patch"
	"${FILESDIR}/${P}-fix-inline-funcs-r1.patch"
)

src_prepare() {
	default
	has_version ">=dev-libs/openssl-1.1.0" && eapply "${FILESDIR}/${P}-openssl-1.1.patch"
}

src_configure() {
	econf \
		--disable-python \
		$(use_enable pcap) \
		$(use_enable ssl cryptcab) \
		$(use_enable static-libs static)
}

src_compile() {
	emake -j1
}

src_install() {
	default
	find "${D}" -name '*.la' -type f -delete || die

	newinitd "${FILESDIR}"/vde.init-r1 vde
	newconfd "${FILESDIR}"/vde.conf-r1 vde
}

pkg_postinst() {
	einfo "To start vde automatically add it to the default runlevel:"
	einfo "# rc-update add vde default"
	einfo "You need to setup tap0 in /etc/conf.d/net"
	einfo "To use it as an user be sure to set a group in /etc/conf.d/vde"
}
