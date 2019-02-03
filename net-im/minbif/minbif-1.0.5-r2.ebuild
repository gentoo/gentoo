# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit cmake-utils user

DESCRIPTION="IRC gateway to IM networks"
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
	gnutls? ( net-libs/gnutls )
	imlib? ( media-libs/imlib2 )
	libcaca? (
		media-libs/imlib2
		media-libs/libcaca
	)
	pam? ( sys-libs/pam )
"
RDEPEND="${DEPEND}
	virtual/logger
	xinetd? ( sys-apps/xinetd )
"

PATCHES=(
	"${FILESDIR}/${PN}-1.0.5-glib-single-includes.patch"
	"${FILESDIR}/${PN}-1.0.5-gcc47.patch"
	"${FILESDIR}/${PN}-1.0.5-rename-imlib-load-error.patch"
)

pkg_setup() {
	enewgroup minbif
	enewuser minbif -1 -1 /var/lib/minbif minbif
}

src_prepare() {
	cmake-utils_src_prepare

	sed -i "s/-Werror//g" CMakeLists.txt || die "sed failed"

	sed -i "s#share/doc/minbif#share/doc/${P}#" \
		CMakeLists.txt || die "sed failed"

	if use xinetd; then
		sed -i "s/type\s=\s[0-9]/type = 0/" \
			minbif.conf || die "sed failed"
	fi
}

src_configure() {
	local mycmakeargs=(
		-DCONF_PREFIX="${EPREFIX}"/etc/minbif
		-DENABLE_VIDEO=OFF
		-DENABLE_TLS=$(usex gnutls)
		-DENABLE_IMLIB=$(usex imlib)
		-DENABLE_CACA=$(usex libcaca)
		-DENABLE_PAM=$(usex pam)
	)

	cmake-utils_src_configure
}

src_install() {
	cmake-utils_src_install
	keepdir /var/lib/minbif
	fperms 700 /var/lib/minbif
	fowners minbif:minbif /var/lib/minbif

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
