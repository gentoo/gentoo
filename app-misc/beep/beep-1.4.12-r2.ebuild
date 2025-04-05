# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit fcaps toolchain-funcs

DESCRIPTION="Advanced PC speaker beeper"
HOMEPAGE="https://github.com/spkr-beep/beep"
SRC_URI="https://github.com/spkr-beep/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 arm ppc ppc64 sparc x86"

# Tests require a speaker
RESTRICT="test"

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
}

pkg_postinst() {
	fcaps -m 0755 cap_dac_override,cap_sys_tty_config usr/bin/beep

	elog "Please note that for security reasons, beep will no longer allow"
	elog "to running w/ SUID or as root under sudo. You will need to give"
	elog "permissions for the PC speaker device to allow non-root users to"
	elog "use 'beep' by either:"
	elog "  setfacl -m u:<youruser>:rw /dev/input/by-path/platform-pcspkr-event-spkr"
	elog "or add yourself to the 'input' group:"
	elog "  usermod -aG input <youruser>"
	elog "It's preferred to use setfacl with least privilege."
}
