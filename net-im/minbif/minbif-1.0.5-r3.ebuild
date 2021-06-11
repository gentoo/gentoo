# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake

DESCRIPTION="IRC gateway to IM networks"
HOMEPAGE="https://symlink.me/projects/minbif/wiki/"
SRC_URI="https://symlink.me/attachments/download/148/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~arm x86"
IUSE="gnutls +imlib +libcaca pam xinetd"
REQUIRED_USE="libcaca? ( imlib )"

DEPEND="
	acct-group/minbif
	acct-user/minbif
	net-im/pidgin
	gnutls? ( net-libs/gnutls )
	imlib? ( media-libs/imlib2 )
	libcaca? (
		media-libs/imlib2
		media-libs/libcaca
	)
	pam? ( sys-libs/pam )
"
RDEPEND="
	${DEPEND}
	virtual/logger
	xinetd? ( sys-apps/xinetd )
"

PATCHES=(
	"${FILESDIR}/${PN}-1.0.5-glib-single-includes.patch"
	"${FILESDIR}/${PN}-1.0.5-gcc47.patch"
	"${FILESDIR}/${PN}-1.0.5-rename-imlib-load-error.patch"
)

src_prepare() {
	cmake_src_prepare

	sed "s/-Werror//g" -i CMakeLists.txt || die

	if use xinetd; then
		sed "s/type\s=\s[0-9]/type = 0/" -i minbif.conf || die
	fi
}

src_configure() {
	local mycmakeargs=(
		-DCONF_PREFIX="${EPREFIX}"/etc/minbif
		-DDOC_PREFIX="${EPREFIX}"/usr/share/doc/"${PF}"
		-DENABLE_VIDEO=OFF
		-DENABLE_TLS=$(usex gnutls)
		-DENABLE_IMLIB=$(usex imlib)
		-DENABLE_CACA=$(usex libcaca)
		-DENABLE_PAM=$(usex pam)
	)

	cmake_src_configure
}

src_install() {
	cmake_src_install
	keepdir /var/lib/minbif
	fperms 700 /var/lib/minbif
	fowners minbif:minbif /var/lib/minbif

	doman man/minbif.8

	if use xinetd; then
		insinto /etc/xinetd.d
		newins doc/minbif.xinetd minbif
	fi

	newinitd "${FILESDIR}"/minbif.initd minbif

	insinto /usr/share/minbif
	doins -r scripts
}
