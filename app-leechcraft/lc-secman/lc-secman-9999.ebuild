# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit leechcraft

DESCRIPTION="Security and personal data manager for LeechCraft"

SLOT="0"
KEYWORDS=""
IUSE="crypt debug exposecontents"

DEPEND="~app-leechcraft/lc-core-${PV}
	dev-qt/qtwidgets:5
	crypt? ( dev-libs/openssl:0 )
"
RDEPEND="${DEPEND}"

src_configure() {
	local mycmakeargs=(
		-DENABLE_SECMAN_SECURESTORAGE=$(usex crypt)
		-DWITH_SECMAN_EXPOSE_CONTENTSDISPLAY=$(usex exposecontents)
	)

	cmake_src_configure
}
