# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit meson systemd

DESCRIPTION="An MPD client that submits information to Audioscrobbler"
HOMEPAGE="
	https://www.musicpd.org/clients/mpdscribble/
	https://github.com/MusicPlayerDaemon/mpdscribble
"
SRC_URI="https://www.musicpd.org/download/${PN}/${PV}/${P}.tar.xz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~ppc x86"

RDEPEND="
	dev-libs/boost
	dev-libs/libgcrypt:=
	media-libs/libmpdclient
	net-misc/curl
"

DEPEND="${RDEPEND}"

DOCS=( AUTHORS COPYING NEWS README.rst )

PATCHES=(
	"${FILESDIR}"/${PN}-0.23-Unconditionally-generate-systemd-unit-files.patch
	"${FILESDIR}"/${PN}-0.23-Don-t-install-AUTHORS-COPYING-NEWS-README.rst.patch
	"${FILESDIR}"/${PN}-0.23-gcc12-time.patch
)

src_install() {
	meson_src_install
	newinitd "${FILESDIR}/mpdscribble.rc" mpdscribble
	keepdir /var/cache/mpdscribble

	systemd_dounit "${BUILD_DIR}"/systemd/system/"${PN}".service
	systemd_douserunit "${BUILD_DIR}"/systemd/user/"${PN}".service
}
