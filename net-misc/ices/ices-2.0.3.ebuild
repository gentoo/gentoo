# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools eapi9-ver toolchain-funcs systemd

DESCRIPTION="Icecast OGG streaming client, supports on the fly re-encoding"
HOMEPAGE="https://icecast.org/ices/ https://gitlab.xiph.org/xiph/icecast-ices/"
SRC_URI="https://downloads.xiph.org/releases/${PN}/${P}.tar.bz2"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~ppc64 ~sparc ~x86"

RDEPEND="
	acct-group/ices
	acct-user/ices
	dev-libs/libxml2:=
	media-libs/alsa-lib
	media-libs/libogg
	media-libs/libshout
	media-libs/libvorbis
"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

PATCHES=(
	"${FILESDIR}"/${PN}-2.0.2-libogg-test.patch
)

src_prepare() {
	default

	eautoconf #740794
}

src_configure() {
	# used by xml2-config
	tc-export PKG_CONFIG
	# used for libshout
	export ac_cv_path_PKGCONFIG="${PKG_CONFIG}"
	local myeconfargs=(
		--enable-alsa
		--disable-roaraudio
	)
	econf "${myeconfargs[@]}"
}

src_install() {
	local HTML_DOCS=( doc/*.{html,css} )

	default

	insinto /etc/ices2
	insopts -m0640 -g ices
	doins conf/*.xml
	newins conf/ices-alsa.xml ices.xml

	newinitd "${FILESDIR}"/ices.initd-r2 ices
	systemd_dounit "${FILESDIR}"/${PN}.service

	diropts -m0764 -o ices -g ices
	dodir /var/log/ices
	keepdir /var/log/ices

	rm -r "${ED}"/usr/share/ices || die
}

pkg_postinst() {
	if ver_replacing -lt 2.0.3; then
		ewarn "Daemon is now launched with unprivileged ices:ices by OpenRC/systemd."
		ewarn "To prevent permission conflicts, please check existing files/dir:"
		ewarn "    ${EROOT}/etc/ices2/ices.xml"
		ewarn "    ${EROOT}/var/log/ices"
	fi
}
