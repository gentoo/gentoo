# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

DESCRIPTION="Steam protocol plugin for pidgin"
HOMEPAGE="https://github.com/eionrobb/pidgin-opensteamworks"
SRC_URI="https://github.com/EionRobb/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 ~ppc x86"
IUSE=""

RDEPEND="
	app-crypt/libsecret
	dev-libs/glib:2
	dev-libs/json-glib
	dev-libs/nss
	net-im/pidgin"
DEPEND="${RDEPEND}"
BDEPEND="
	app-arch/unzip
	virtual/pkgconfig"

S=${WORKDIR}

pkg_setup() {
	if [[ ${MERGE_TYPE} != binary ]]; then
		tc-export CC PKG_CONFIG
	fi
}

src_prepare() {
	default

	unzip "${S}"/${P}/steam-mobile/releases/icons.zip || die
}

src_compile() {
	pushd ${P}/steam-mobile || die
	default
	popd || die
}

src_install() {
	pushd ${P}/steam-mobile || die
	default
	popd || die
	insinto /usr/share/pixmaps/pidgin/protocols
	doins -r "${WORKDIR}"/{16,48}
	dodoc ${P}/README.md
}
