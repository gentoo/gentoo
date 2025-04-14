# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit meson verify-sig

MY_P="${P}.20250411"

DESCRIPTION="Command line tools and C library for accessing Mega cloud storage"
HOMEPAGE="https://xff.cz/megatools/"
SRC_URI="https://xff.cz/megatools/builds/builds/${MY_P}.tar.gz
	verify-sig? ( https://xff.cz/megatools/builds/builds/${MY_P}.tar.gz.asc )"
S="${WORKDIR}/${MY_P}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"

RDEPEND="
	dev-libs/glib:2
	dev-libs/openssl:0=
	net-libs/glib-networking[ssl]
	net-misc/curl
"
DEPEND="${RDEPEND}"
BDEPEND="
	app-text/asciidoc
	verify-sig? ( sec-keys/openpgp-keys-ondrejjirman )
	virtual/pkgconfig
"

VERIFY_SIG_OPENPGP_KEY_PATH=/usr/share/openpgp-keys/ondrejjirman.asc

src_prepare() {
	# upstream forgot to bump the version in the build system again
	sed -i "s/1.11.3/${PV}/" meson.build || die

	default
}

src_install() {
	meson_src_install

	rm -r "${ED}/usr/share/doc/${PN}" || die
}
