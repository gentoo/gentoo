# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools toolchain-funcs

DESCRIPTION="network Audit Record Generation and Utilization System"
HOMEPAGE="https://openargus.org/"
SRC_URI="https://www.qosient.com/argus/dev/${P/_rc/.rc.}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 ppc ~x86 ~amd64-linux ~x86-linux ~ppc-macos"
IUSE="debug sasl tcpd"

RDEPEND="
	acct-group/argus
	acct-user/argus
	net-libs/libnsl:=
	net-libs/libpcap
	net-libs/libtirpc
	sys-libs/zlib
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
	"${FILESDIR}"/${PN}-3.0.8.3-ar.patch
	"${FILESDIR}"/${PN}-3.0.8.3-as-needed.patch
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

	econf \
		$(use_with sasl) \
		$(use_with tcpd wrappers)
}

src_compile() {
	emake \
		CCOPT="${CFLAGS} ${LDFLAGS}" \
		AR="$(tc-getAR)" \
		RANLIB="$(tc-getRANLIB)"
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
