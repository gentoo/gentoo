# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs

DESCRIPTION="DockApp monitors the temperature and Speedstep features in ACPI-based systems"
HOMEPAGE="https://wiki.gentoo.org/wiki/No_homepage"
SRC_URI="https://downloads.sourceforge.net/${PN}/${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 x86"

RDEPEND="x11-libs/libX11
	x11-libs/libXext
	x11-libs/libXpm"
DEPEND="${RDEPEND}
	x11-base/xorg-proto"

PATCHES=(
	# patch wmacpimon.c file to set default path for
	# wmacpimon.prc to /var/tmp/
	"${FILESDIR}/wmacpimon.c.patch"

	# fix LDFLAGS ordering. See bug #248618.
	# fix LDFLAGS ordering again and other stuff. See bug #336091.
	"${FILESDIR}/Makefile.patch"
)

src_compile() {
	tc-export CC
	default
}

src_install() {
	dobin wmacpimond wmacpimon
	dodoc AUTHORS ChangeLog README
	newinitd "${FILESDIR}"/wmacpimon.initscript wmacpimon
}

pkg_postinst() {
	elog "Remember to start the wmacpimond daemon"
	elog "(by issuing the \"/etc/init.d/wmacpimon start\" command)"
	elog "before you attempt to run wmacpimon..."
}
