# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="8"

inherit cmake xdg-utils

DESCRIPTION="A GUI to OpenSSL, RSA public keys, certificates, signing requests etc"
HOMEPAGE="https://hohnstaedt.de/xca/"
#SRC_URI="https://github.com/chris2511/${PN}/releases/download/RELEASE.${PV}/${P}.tar.gz"
SRC_URI="https://github.com/chris2511/xca/archive/refs/tags/RELEASE.${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/xca-RELEASE.${PV}"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ~ppc x86 ~amd64-linux ~x86-linux ~ppc-macos"
IUSE="doc"

RDEPEND="
	dev-libs/libltdl:0=
	dev-qt/qthelp:5
	dev-qt/qtgui:5
	dev-qt/qtsql:5[sqlite]
	dev-qt/qtwidgets:5
	dev-libs/openssl:*
	doc? ( app-text/linuxdoc-tools )"
DEPEND="${RDEPEND}"
BDEPEND="dev-qt/linguist-tools:5 doc? ( dev-python/sphinx dev-python/sphinxcontrib-htmlhelp dev-python/sphinxcontrib-qthelp )"

PATCHES=(
	"${FILESDIR}/${PN}-1.0.0-desktop.patch"
	"${FILESDIR}/${PN}-2.4.0-man-page.patch"
)

src_configure() {
	local mycmakeargs=(
		-DQTFIXEDVERSION=Qt5
	)
	cmake_src_configure
}

src_compile() {
	cmake_src_compile
}

src_install() {
	cmake_src_install

	insinto /etc/xca
	doins misc/*.txt

	dosym xca /usr/bin/xca-console
}

pkg_postinst() {
	xdg_icon_cache_update
	xdg_desktop_database_update
	xdg_mimeinfo_database_update
}

pkg_postrm() {
	xdg_icon_cache_update
	xdg_desktop_database_update
	xdg_mimeinfo_database_update
}
