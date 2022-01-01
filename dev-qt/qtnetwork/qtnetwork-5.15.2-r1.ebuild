# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

QT5_MODULE="qtbase"
inherit qt5-build

DESCRIPTION="Network abstraction library for the Qt5 framework"
SRC_URI+=" https://dev.gentoo.org/~asturm/distfiles/qtbase-${PV}-gcc11.patch.xz"

if [[ ${QT5_BUILD_TYPE} == release ]]; then
	KEYWORDS="amd64 arm arm64 ~hppa ppc ppc64 ~sparc x86"
fi

IUSE="bindist connman gssapi libproxy networkmanager sctp +ssl"

DEPEND="
	~dev-qt/qtcore-${PV}:5=
	sys-libs/zlib:=
	connman? ( ~dev-qt/qtdbus-${PV} )
	gssapi? ( virtual/krb5 )
	libproxy? ( net-libs/libproxy )
	networkmanager? ( ~dev-qt/qtdbus-${PV} )
	sctp? ( kernel_linux? ( net-misc/lksctp-tools ) )
	ssl? (
		>=dev-libs/openssl-1.1.1:0=[bindist=]
	)
"
RDEPEND="${DEPEND}
	connman? ( net-misc/connman )
	networkmanager? ( net-misc/networkmanager )
"

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

PATCHES=(
	"${FILESDIR}"/${P}-QNetworkAccessManager-memleak.patch # QTBUG-88063
	"${FILESDIR}"/${PN}-5.15.2-libressl.patch # Bug 562050, not upstreamable
	"${WORKDIR}"/qtbase-${PV}-gcc11.patch # bug 752012
)

pkg_setup() {
	use connman && QT5_TARGET_SUBDIRS+=(src/plugins/bearer/connman)
	use networkmanager && QT5_TARGET_SUBDIRS+=(src/plugins/bearer/networkmanager)
}

src_configure() {
	local myconf=(
		$(usex connman -dbus-linked '')
		$(usex gssapi -feature-gssapi -no-feature-gssapi)
		$(qt_use libproxy)
		$(usex networkmanager -dbus-linked '')
		$(qt_use sctp)
		$(usex ssl -openssl-linked '')
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
