# Copyright 1999-2024 Gentoo Authors
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
	doman "${PN}.1"

	fperms 0711 /usr/bin/beep

	local DOCS=(
		CREDITS.md DEVELOPMENT.md INSTALL.md NEWS.md PACKAGING.md PERMISSIONS.md README.md
	)
	einstalldocs
}

pkg_postinst() {
	FILECAPS=(
		-m0711 cap_dac_override,cap_sys_tty_config "${EROOT}/usr/bin/beep"
	)

	elog "Please note that for security reasons, beep will no longer allow"
	elog "to running w/ SUID or as root under sudo. You will need to give"
	elog "permissions for the PC speaker device to allow non-root users to"
	elog "use 'beep' by either:"
	elog "  setfacl -m u:<youruser>:rw /dev/input/by-path/platform-pcspkr-event-spkr"
	elog "or add yourself to the 'input' group:"
	elog "  usermod -aG input <youruser>"
	elog "It's preferred to use setfacl with least privilege."
}
