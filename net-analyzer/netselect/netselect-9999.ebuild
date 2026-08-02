# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit fcaps git-r3 toolchain-funcs

DESCRIPTION="Ultrafast implementation of ping"
HOMEPAGE="http://apenwarr.ca/netselect/"
EGIT_REPO_URI="https://github.com/apenwarr/${PN}"
S="${WORKDIR}/${PN}-${P}"

LICENSE="BSD"
SLOT="0"

PATCHES=(
	"${FILESDIR}"/${PN}-0.4-bsd.patch
	"${FILESDIR}"/${PN}-0.4-flags.patch
)

DOCS=( HISTORY README )

FILECAPS=( -g wheel cap_net_raw usr/bin/netselect )

src_prepare() {
	default

	# Don't warn about "root privileges required" when running as
	# an unprivileged user with filecaps
	if ! use prefix && use filecaps; then
		sed -i -e '/if (geteuid () != 0)/,+2d' "${S}"/netselect.c || die
	fi
}

src_compile() {
	emake CC="$(tc-getCC)" LDFLAGS="${CFLAGS} ${LDFLAGS}"
}

src_install() {
	dobin netselect

	einstalldocs

	doman netselect.1
}

pkg_postinst() {
	! use prefix && fcaps_pkg_postinst
}
