# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit flag-o-matic

if [[ ${PV} == 9999 ]]; then
	inherit autotools git-r3
	EGIT_REPO_URI="https://github.com/virtualsqaure/MY_PN"
	KEYWORDS=""
elif [[ ${PV} = *_p* ]]; then
	inherit autotools
	MY_PN="vde-2"
	COMMIT="c7b36a57831a9067c8619c3e17a03e595623b3eb"
	SRC_URI="https://github.com/virtualsquare/${MY_PN}/archive/${COMMIT}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~arm64 ~ppc ~ppc64 ~x86"

	S="${WORKDIR}/${MY_PN}-${COMMIT}"
else
	MY_P="${PN}2-${PV}"
	SRC_URI="mirror://sourceforge/vde/${MY_P}.tar.bz2"
	KEYWORDS="~amd64 ~arm64 ~ppc ~ppc64 ~x86"
	S="${WORKDIR}/${MY_P}"
fi

DESCRIPTION="Virtual distributed ethernet emulator for emulators like qemu, bochs, and uml"
HOMEPAGE="https://virtualsquare.org"

LICENSE="GPL-2"
SLOT="0"
#IUSE="pcap selinux ssl libressl static-libs"
# upstream switched to wolfssl
IUSE="pcap selinux static-libs"

COMMON_DEPS="pcap? ( net-libs/libpcap )"
# upstream switched to wolfssl
#	ssl? (
#		!libressl? ( dev-libs/openssl:0= )
#		libressl? ( dev-libs/libressl:0= )
#	)"
DEPEND="${COMMON_DEPS}"
RDEPEND="${COMMON_DEPS}
	acct-group/qemu
	selinux? ( sec-policy/selinux-vde )"

PATCHES=(
	"${FILESDIR}/${PN}-2.3.2-slibtool-support.patch"
)

# upstream switched to wolfssl
src_prepare() {
	default
	if [[ ${PV} == 9999 ]] || [[ ${PV} == *_p* ]]; then
		eautoreconf
	fi
# upstream switched to wolfssl
#	has_version ">=dev-libs/openssl-1.1.0" && \
#		eapply "${FILESDIR}/${PN}-2.3.2-openssl-1.1.patch"
}

src_configure() {
	filter-flags -O0 -Os
# upstream switched to wolfssl
#		$(use_enable ssl cryptcab) \
	econf \
		--disable-python \
		--disable-cryptcab \
		$(use_enable pcap) \
		$(use_enable static-libs static)
}

src_compile() {
	# https://github.com/virtualsquare/vde-2/issues/6
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
