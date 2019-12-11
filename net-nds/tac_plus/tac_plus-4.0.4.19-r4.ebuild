# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit autotools base libtool

MY_P="tacacs+-F${PV}"
S="${WORKDIR}/${MY_P}"

DESCRIPTION="An updated version of Cisco's TACACS+ server"
HOMEPAGE="http://www.shrubbery.net/tac_plus/"
SRC_URI="ftp://ftp.shrubbery.net/pub/tac_plus/${MY_P}.tar.gz"

LICENSE="HPND RSA GPL-2" # GPL-2 only for init script
SLOT="0"
KEYWORDS="amd64 ppc x86"
IUSE="debug finger maxsess tcpd skey static-libs"

DEPEND="skey? ( >=sys-auth/skey-1.1.5-r1 )
	tcpd? ( sys-apps/tcp-wrappers )
	sys-libs/pam"
RDEPEND="${DEPEND}"

PATCHES=(
"${FILESDIR}/${P}-parallelmake.patch"
"${FILESDIR}/${P}-deansification.patch"
)

src_prepare() {
	base_src_prepare
	AT_M4DIR="." eautoreconf
	elibtoolize
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

	use static-libs || find "${D}" -name '*.la' -delete || die "Unable to remove spurious libtool archive"
	dodoc CHANGES FAQ

	newinitd "${FILESDIR}/tac_plus.init2" tac_plus
	newconfd "${FILESDIR}/tac_plus.confd2" tac_plus

	insinto /etc/tac_plus
	newins "${FILESDIR}/tac_plus.conf2" tac_plus.conf
}
