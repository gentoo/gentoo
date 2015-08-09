# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="3"

inherit eutils base

MY_PN="PackageKit"
MY_P=${MY_PN}-${PV}

DESCRIPTION="Qt4 PackageKit backend library"
HOMEPAGE="http://www.packagekit.org/"
SRC_URI="http://www.packagekit.org/releases/${MY_P}.tar.xz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"
IUSE=""

RDEPEND=">=dev-qt/qtcore-4.4.0:4
	>=dev-qt/qtdbus-4.4.0:4
	>=dev-qt/qtsql-4.4.0:4
	~app-admin/packagekit-base-${PV}"
DEPEND="${RDEPEND}
	dev-libs/libxslt
	virtual/pkgconfig"

S="${WORKDIR}/${MY_P}"

src_configure() {
	# http://pkgs.fedoraproject.org/gitweb/?p=PackageKit.git;a=commit;h=0b378668288db34890b82c7be007fc76c7fcd956
	sed -i -e '/polkit-backend-1/d' configure || die #423431
	econf \
		--enable-introspection=no \
		--localstatedir=/var \
		--disable-dependency-tracking \
		--enable-option-checking \
		--enable-libtool-lock \
		--disable-strict \
		--disable-local \
		--disable-gtk-doc \
		--disable-command-not-found \
		--disable-debuginfo-install \
		--disable-gstreamer-plugin \
		--disable-service-packs \
		--disable-man-pages \
		--disable-cron \
		--disable-gtk-module \
		--disable-networkmanager \
		--disable-browser-plugin \
		--disable-pm-utils \
		--disable-device-rebind \
		--disable-tests \
		--enable-qt
}

src_compile() {
	local qtdir=packagekit-qt2
	cd "${S}"/lib/${qtdir} || die
	emake || die "emake install failed"
}

src_install() {
	local qtdir=packagekit-qt2
	cd "${S}"/lib/${qtdir} || die
	emake DESTDIR="${D}" install || die "emake install failed"
}
