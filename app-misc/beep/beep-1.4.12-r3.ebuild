# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs udev

DESCRIPTION="Advanced PC speaker beeper"
HOMEPAGE="https://github.com/spkr-beep/beep"
SRC_URI="https://github.com/spkr-beep/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~ppc ~ppc64 ~sparc ~x86"

# Tests require a speaker
RESTRICT="test"

RDEPEND="
	acct-group/beep
"

PATCHES=( "${FILESDIR}"/${P}-avoid-cref-linker-option.patch )

src_prepare() {
	default

	cat <<-EOF > local.mk || die
	CC=$(tc-getCC)
	CFLAGS=${CFLAGS}
	CPPFLAGS=${CPPFLAGS}
	LDFLAGS=${LDFLAGS}
	EOF

	sed -i \
		-e "s#-D_FORTIFY_SOURCE=2##g;" \
		-e '/\-Werror)/d' \
		GNUmakefile || die
}

src_install() {
	dobin beep
	doman ${PN}.1
	dodoc CREDITS.md DEVELOPMENT.md NEWS.md PERMISSIONS.md README.md
	udev_dorules "${FILESDIR}"/{70,90}-pcspkr-beep.rules
}

pkg_postinst() {
	udev_reload
	elog "Access to the PC speaker is now controlled by the 'beep' group."
	elog "Local logins are also granted access via logind."
}

pkg_postrm() {
	udev_reload
}
