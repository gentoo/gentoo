# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit cmake-utils eutils user

DESCRIPTION="an IRC gateway to IM networks"
HOMEPAGE="https://symlink.me/projects/minbif/wiki/"
SRC_URI="https://symlink.me/attachments/download/148/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~arm x86"
IUSE="gnutls +imlib +libcaca pam xinetd"
REQUIRED_USE="
	libcaca? ( imlib )
"

DEPEND="
	>=net-im/pidgin-2.6
	libcaca? ( media-libs/libcaca media-libs/imlib2 )
	imlib? ( media-libs/imlib2 )
	pam? ( sys-libs/pam )
	gnutls? ( net-libs/gnutls )
"
RDEPEND="${DEPEND}
	virtual/logger
	xinetd? ( sys-apps/xinetd )
"

pkg_setup() {
	enewgroup minbif
	enewuser minbif -1 -1 /var/lib/minbif minbif
}

src_prepare() {
	epatch "${FILESDIR}/${PN}-1.0.5-glib-single-includes.patch"
	epatch "${FILESDIR}/${PN}-1.0.5-gcc47.patch"
	epatch "${FILESDIR}/${PN}-1.0.5-rename-imlib-load-error.patch"

	sed -i "s/-Werror//g" CMakeLists.txt || die "sed failed"

	sed -i "s#share/doc/minbif#share/doc/${P}#" \
		CMakeLists.txt || die "sed failed"

	if use xinetd; then
		sed -i "s/type\s=\s[0-9]/type = 0/" \
			minbif.conf || die "sed failed"
	fi
}

src_configure() {
	local mycmakeargs
	mycmakeargs="${mycmakeargs}
		-DCONF_PREFIX=${PREFIX:-/etc/minbif}
		-DENABLE_VIDEO=OFF
		$(cmake-utils_use_enable libcaca CACA)
		$(cmake-utils_use_enable imlib IMLIB)
		$(cmake-utils_use_enable pam PAM)
		$(cmake-utils_use_enable gnutls TLS)"

	cmake-utils_src_configure
}

src_install() {
	cmake-utils_src_install
	keepdir /var/lib/minbif
	fperms 700 /var/lib/minbif
	fowners minbif:minbif /var/lib/minbif

	dodoc ChangeLog README
	doman man/minbif.8

	if use xinetd; then
		insinto /etc/xinetd.d
		newins doc/minbif.xinetd minbif
	fi

	newinitd "${FILESDIR}"/minbif.initd minbif

	dodir /usr/share/minbif
	insinto /usr/share/minbif
	doins -r scripts
}
