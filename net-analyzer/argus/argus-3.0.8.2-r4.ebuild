# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools

DESCRIPTION="network Audit Record Generation and Utilization System"
HOMEPAGE="https://openargus.org/"
SRC_URI="https://www.qosient.com/argus/dev/${P/_rc/.rc.}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86 ~amd64-linux ~x86-linux ~ppc-macos"
IUSE="debug +libtirpc sasl tcpd"

RDEPEND="
	acct-group/argus
	acct-user/argus
	net-libs/libnsl:=
	net-libs/libpcap
	sys-libs/zlib
	!libtirpc? ( sys-libs/glibc[rpc(-)] )
	libtirpc? ( net-libs/libtirpc )
	sasl? ( dev-libs/cyrus-sasl )
	tcpd? ( >=sys-apps/tcp-wrappers-7.6 )
"
DEPEND="${RDEPEND}"
BDEPEND="
	>=sys-devel/bison-1.28
	>=sys-devel/flex-2.4.6
"
PATCHES=(
	"${FILESDIR}"/${PN}-3.0.8.1-disable-tcp-wrappers-automagic.patch
	"${FILESDIR}"/${PN}-3.0.5-Makefile.patch
	"${FILESDIR}"/${PN}-3.0.7.3-DLT_IPNET.patch
	"${FILESDIR}"/${PN}-3.0.8.2-rpc.patch
	"${FILESDIR}"/${PN}-3.0.8.2-fno-common.patch
)
S=${WORKDIR}/${P/_rc/.rc.}

src_prepare() {
	find . -type f -execdir chmod +w {} \; #561360
	sed -e 's:/etc/argus.conf:/etc/argus/argus.conf:' \
		-i argus/argus.c \
		-i support/Config/argus.conf \
		-i man/man8/argus.8 \
		-i man/man5/argus.conf.5 || die

	sed -e 's:#\(ARGUS_SETUSER_ID=\).*:\1argus:' \
		-e 's:#\(ARGUS_SETGROUP_ID=\).*:\1argus:' \
		-e 's:\(#ARGUS_CHROOT_DIR=\).*:\1/var/lib/argus:' \
			-i support/Config/argus.conf || die

	default
	eautoreconf
}

src_configure() {
	use debug && touch .debug # enable debugging
	econf $(use_with libtirpc) $(use_with tcpd wrappers) $(use_with sasl)
}

src_compile() {
	emake CCOPT="${CFLAGS} ${LDFLAGS}"
}

src_install() {
	doman man/man5/*.5 man/man8/*.8

	dosbin bin/argus{,bug}

	dodoc ChangeLog CREDITS README

	insinto /etc/argus
	doins support/Config/argus.conf

	newinitd "${FILESDIR}/argus.initd" argus
	keepdir /var/lib/argus
}

pkg_postinst() {
	elog "Note, if you modify ARGUS_DAEMON value in argus.conf it's quite"
	elog "possible that the init script will fail to work."
}
