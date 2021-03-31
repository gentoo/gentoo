# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools pam

MY_P="tacacs+-F${PV}"
DESCRIPTION="An updated version of Cisco's TACACS+ server"
HOMEPAGE="http://www.shrubbery.net/tac_plus/"
SRC_URI="ftp://ftp.shrubbery.net/pub/tac_plus/${MY_P}.tar.gz"
S="${WORKDIR}/${MY_P}"

LICENSE="HPND RSA GPL-2" # GPL-2 only for init script
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="debug finger maxsess tcpd skey static-libs"

DEPEND="
	net-libs/libnsl
	sys-libs/pam
	skey? ( >=sys-auth/skey-1.1.5-r1 )
	tcpd? ( sys-apps/tcp-wrappers )
"
RDEPEND="${DEPEND}"

PATCHES=(
	"${FILESDIR}/${P}-parallelmake.patch"
	"${FILESDIR}/${PN}-4.0.4.19-deansification.patch"
)

src_prepare() {
	default

	mv configure.in configure.ac || die "Unable to quiet autoconf deprecation warning"
	AT_M4DIR="." eautoreconf

}

src_configure() {
	econf \
		$(use_with skey) \
		$(use_with tcpd libwrap) \
		$(use_enable debug) \
		$(use_enable finger) \
		$(use_enable maxsess) \
		$(use_enable static-libs static)
}

src_install() {
	emake DESTDIR="${D}" install

	if use static-libs ; then
		find "${ED}" -name '*.la' -delete || die "Unable to remove spurious libtool archive"
	fi

	dodoc CHANGES FAQ

	newinitd "${FILESDIR}/tac_plus.init2" tac_plus
	newconfd "${FILESDIR}/tac_plus.confd2" tac_plus

	# bug #474860
	pamd_mimic_system tac_plus auth account password session

	insinto /etc/tac_plus
	newins "${FILESDIR}/tac_plus.conf2" tac_plus.conf
}
