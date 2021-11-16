# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="8"

inherit xdg-utils

DESCRIPTION="A GUI to OpenSSL, RSA public keys, certificates, signing requests etc"
HOMEPAGE="https://hohnstaedt.de/xca/"
SRC_URI="https://github.com/chris2511/${PN}/releases/download/RELEASE.${PV}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ~ppc x86 ~amd64-linux ~x86-linux ~ppc-macos"
IUSE="bindist doc"

RDEPEND="
	dev-libs/libltdl:0=
	dev-qt/qthelp:5
	dev-qt/qtgui:5
	dev-qt/qtsql:5[sqlite]
	dev-qt/qtwidgets:5
	>=dev-libs/openssl-1.1.0:0=[bindist(-)=]
	doc? ( app-text/linuxdoc-tools )"
DEPEND="${RDEPEND}
	dev-qt/linguist-tools:5"

PATCHES=(
	"${FILESDIR}/${PN}-1.0.0-desktop.patch"
	"${FILESDIR}/${P}-bug-733000.patch"
)

src_configure() {
	econf \
		--with-qt-version=5 \
		$(use_enable doc) \
		STRIP=true
}

src_prepare() {
	sed '/^CFLAGS/s@-O2 -ggdb@@' -i Local.mak.in || die
	default
}

src_compile() {
	# enforce all to avoid the automatic silent rules
	emake all
}

src_install() {
	default

	insinto /etc/xca
	doins misc/*.txt

	ewarn "Make a backup copy of your database!"
	ewarn "Version 2 completely changes the database format to SQL(ite)"
	ewarn "Don't try to open it with older versions of XCA (< 1.4.0). They will corrupt the database."
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
