# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs flag-o-matic desktop xdg

DESCRIPTION="Advanced file encryption using AES"
HOMEPAGE="https://www.aescrypt.com/"
SRC_URI="https://www.aescrypt.com/download/v$(ver_cut 1)/linux/${P}.tgz"

LICENSE="BSD GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm64"
IUSE="static X"

RDEPEND="
	X? (
		|| ( gnome-extra/zenity kde-apps/kdialog )
		dev-lang/perl
	)
	"

PATCHES=(
	"${FILESDIR}/${P}-iconv.patch"
)

src_prepare() {
	sed -i \
		-e 's:Icon=/usr/share/aescrypt/SmallLock.png:Icon=SmallLock:' \
		-e 's|Categories=Application;Utility;TextEditor;|Categories=Utility;TextEditor;|' \
		gui/AESCrypt.desktop || die

	default
}

src_compile() {
	if use static; then
		append-cflags "-DDISABLE_ICONV"
		append-ldflags "-static"
	fi
	cd src || die
	emake \
		CFLAGS="${CFLAGS} -Wall -Wextra -pedantic -std=c99 -D_FILE_OFFSET_BITS=64" \
		LDFLAGS="${LDFLAGS}" \
		CC="$(tc-getCC)"
}

src_test() {
	cd src || die
	emake -j1 test \
		CFLAGS="${CFLAGS} -Wall -Wextra -pedantic -std=c99 -D_FILE_OFFSET_BITS=64" \
		LDFLAGS="${LDFLAGS}" \
		CC="$(tc-getCC)"
}

src_install() {
	dobin src/{aescrypt,aescrypt_keygen}
	doman man/*
	doicon gui/SmallLock.png
	domenu gui/AESCrypt.desktop
	dobin gui/aescrypt-gui
}

pkg_postinst() {
	xdg_pkg_postinst
	if use X; then
		einfo 'The .desktop file for aescrypt is only supposed to be used with "Open With"'
		einfo 'to encrypt and decrypt files.'
		einfo 'See:'
		einfo '	https://www.aescrypt.com/linux_aes_crypt.html'
		einfo 'for more information'
	fi
}
