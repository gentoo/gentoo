# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

if [[ ${PV} != *9999* ]]; then
	QT5_KDEPATCHSET_REV=1
	KEYWORDS="~amd64 ~arm ~arm64 ~hppa ~loong ~ppc ~ppc64 ~riscv ~sparc ~x86"
fi

QT5_MODULE="qtbase"
inherit qt5-build

DESCRIPTION="Network abstraction library for the Qt5 framework"

IUSE="gssapi libproxy sctp +ssl"

DEPEND="
	=dev-qt/qtcore-${QT5_PV}*:5=
	sys-libs/zlib:=
	gssapi? ( virtual/krb5 )
	libproxy? ( net-libs/libproxy )
	sctp? ( kernel_linux? ( net-misc/lksctp-tools ) )
	ssl? ( >=dev-libs/openssl-1.1.1:0= )
"
RDEPEND="${DEPEND}"

PATCHES=( "${FILESDIR}/${P}-CVE-2024-39936.patch" ) # bug 935869

QT5_TARGET_SUBDIRS=(
	src/network
	src/plugins/bearer/generic
)

QT5_GENTOO_CONFIG=(
	libproxy:libproxy:
	ssl::SSL
	ssl::OPENSSL
	ssl:openssl-linked:LINKED_OPENSSL
)

QT5_GENTOO_PRIVATE_CONFIG=(
	:network
)

src_configure() {
	local myconf=(
		$(qt_use gssapi feature-gssapi)
		$(qt_use libproxy)
		$(qt_use sctp)
		$(usev ssl -openssl-linked)
	)
	qt5-build_src_configure
}

src_install() {
	qt5-build_src_install

	# workaround for bug 652650
	if use ssl; then
		sed -e "/^#define QT_LINKED_OPENSSL/s/$/ true/" \
			-i "${D}${QT5_HEADERDIR}"/Gentoo/${PN}-qconfig.h || die
	fi
}
