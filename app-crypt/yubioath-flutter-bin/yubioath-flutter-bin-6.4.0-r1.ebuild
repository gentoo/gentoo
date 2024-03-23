# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit desktop xdg

DESCRIPTION="Yubico Authenticator for TOTP"
HOMEPAGE="
	https://developers.yubico.com/yubioath-flutter/
	https://github.com/Yubico/yubioath-flutter"
SRC_URI="https://github.com/Yubico/yubioath-flutter/releases/download/${PV}/yubico-authenticator-${PV}-linux.tar.gz"
S="${WORKDIR}/yubico-authenticator-${PV}-linux"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="-* ~amd64"

RDEPEND="
	app-accessibility/at-spi2-core:2
	app-crypt/ccid
	dev-libs/glib:2
	media-libs/libepoxy
	sys-libs/glibc
	x11-libs/cairo
	x11-libs/gdk-pixbuf:2
	x11-libs/gtk+:3
	x11-libs/libnotify
	x11-libs/libxcb
	x11-libs/pango"
BDEPEND="app-admin/chrpath"

# "Modern" app, built using Google's flutter framework.
#
# Don't even *think* about unbundling the dependencies, they're all
# hardcoded into the main binary and the helper, including but not
# limited to a full-fledged python interpreter that gets dlopen'd, an
# assortment of python packages, the X11 kitchen sink, random GCC
# libraries, and OpenSSL 1.1, oftentimes using git checkouts instead of
# released versioned libraries.
#
# The only way to avoid this mess would be to build flutter from source,
# but unfortunately life is too short to be dealing with whatever is
# Google's framework-de-jour on a regular basis.
QA_PREBUILT="opt/yubico-authenticator/*"

src_install() {
	einstalldocs
	rm -r README* || die

	sed -e 's|@EXEC_PATH/authenticator|authenticator|' \
		-e 's|@EXEC_PATH/linux_support/com.yubico.yubioath.png|com.yubico.yubioath|g' \
		-i linux_support/com.yubico.authenticator.desktop || die
	domenu linux_support/com.yubico.authenticator.desktop
	doicon -s 128 linux_support/com.yubico.yubioath.png
	rm -r linux_support || die

	exeinto /opt/yubico-authenticator
	doexe authenticator
	rm authenticator || die

	exeinto /opt/yubico-authenticator/helper
	doexe helper/authenticator-helper
	rm helper/authenticator-helper || die

	# prevent rpath_security_checks() trigger
	chrpath -d helper/_internal/libjpeg-*.so* helper/_internal/pillow.libs/libjpeg-*.so* || die

	insinto /opt/yubico-authenticator
	doins -r .

	dosym ../../opt/yubico-authenticator/authenticator /usr/bin/authenticator
}

pkg_postinst() {
	xdg_pkg_postinst

	elog "Make sure you are a member of the pcscd group"
	elog "and the pcscd service is running."
}
