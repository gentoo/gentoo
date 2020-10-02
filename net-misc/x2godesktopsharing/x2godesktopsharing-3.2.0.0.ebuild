# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PKGNAME=x2godesktopsharing
PKGVER=3.2.0.0
DESCRIPTION="X2Go add-on tool that allows a user to grant other X2go users access to the current session (shadow session support)."
HOMEPAGE="http://www.x2go.org/"
SRC_URI="https://code.x2go.org/releases/source/${PKGNAME}/${PKGNAME}-${PKGVER}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~x86 ~amd64"

RDEPEND="acct-user/x2godesktopsharinguser"


src_configure() {
	qmake x2godesktopsharing.pro
	make
	
}

src_prepare() {
	default
	
	sed -i \
		-e "s:bin:sbin:" \
		x2godesktopsharing.desktop || die
}

src_install() {

	install -D -m 755 x2godesktopsharing "${D}/usr/sbin/x2godesktopsharing"

	install -d -m 755 "${D}/usr/share/applications"

	install    -m 644 x2godesktopsharing.desktop "${D}/usr/share/applications/x2godesktopsharing.desktop"

	install -d -m 755 "${D}/usr/share/x2godesktopsharing/icons"
	install    -m 644 icons/x2godesktopsharing.xpm "${D}/usr/share/x2godesktopsharing/icons/x2godesktopsharing.xpm"

	install -d -m 755 "${D}/usr/share/icons/hicolor/128x128/apps"
	install    -m 644 icons/128x128/x2godesktopsharing.png "${D}/usr/share/icons/hicolor/128x128/apps/x2godesktopsharing.png"

	install -d -m 755 "${D}/usr/share/icons/hicolor/16x16/apps"
	install    -m 644 icons/16x16/x2godesktopsharing.png "${D}/usr/share/icons/hicolor/16x16/apps/x2godesktopsharing.png"

	install -d -m 755 "${D}/usr/share/icons/hicolor/64x64/apps"
	install    -m 644 icons/64x64/x2godesktopsharing.png "${D}/usr/share/icons/hicolor/64x64/apps/x2godesktopsharing.png"

	install -d -m 755 "${D}/usr/share/icons/hicolor/32x32/apps"
	install    -m 644 icons/32x32/x2godesktopsharing.png "${D}/usr/share/icons/hicolor/32x32/apps/x2godesktopsharing.png"

	gzip man/man1/x2godesktopsharing.1
	install -d -m 755 "${D}/usr/share/man/man1"
	install    -m 644 -t "${D}/usr/share/man/man1" man/man1/x2go*.gz

	# gzip man/man8/x2go*-desktopsharing.8
	# install -d -m 755 "${D}/usr/share/man/man8"
	# install    -m 644 -t "${D}/usr/share/man/man8" man/man8/x2go*-desktopsharing.8.gz

	install -d -m 755 "${D}/usr/share/menu"

	install -d -m 755 "${D}/usr/share/x2go/versions/"
	echo ${PKGVER} > "${D}/usr/share/x2go/versions/VERSION.$PKGNAME"

}
