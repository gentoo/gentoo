# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit leechcraft

DESCRIPTION="Security and personal data manager for LeechCraft"

SLOT="0"
KEYWORDS=""
IUSE="debug crypt exposecontents"

DEPEND="~app-leechcraft/lc-core-${PV}
	crypt? ( dev-libs/openssl:0 )
	dev-qt/qtwidgets:5
"
RDEPEND="${DEPEND}"

src_configure() {
	local mycmakeargs=(
		-DENABLE_SECMAN_SECURESTORAGE=$(usex crypt)
		-DWITH_SECMAN_EXPOSE_CONTENTSDISPLAY=$(usex exposecontents)
	)

	cmake-utils_src_configure
}
