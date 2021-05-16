# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit fcaps git-r3 toolchain-funcs

DESCRIPTION="Ultrafast implementation of ping"
HOMEPAGE="http://apenwarr.ca/netselect/"
EGIT_REPO_URI="https://github.com/apenwarr/${PN}"
SRC_URI="ipv6? ( https://dev.gentoo.org/~jer/${PN}-0.4-ipv6.patch.xz )"
S="${WORKDIR}/${PN}-${P}"

LICENSE="BSD"
SLOT="0"
IUSE="ipv6"

PATCHES=(
	"${FILESDIR}"/${PN}-0.4-bsd.patch
	"${FILESDIR}"/${PN}-0.4-flags.patch
)

DOCS=( HISTORY README )

FILECAPS=( -g wheel cap_net_raw usr/bin/netselect )

src_unpack() {
	use ipv6 && unpack ${A}
	git-r3_src_unpack
}

src_prepare() {
	use ipv6 && eapply "${WORKDIR}"/${PN}-0.4-ipv6.patch

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
