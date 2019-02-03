# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit linux-info systemd toolchain-funcs

DESCRIPTION="Resource-specific view of processes"
HOMEPAGE="https://www.atoptool.nl/ https://github.com/Atoptool/atop"
SRC_URI="https://github.com/Atoptool/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

# Tarballs lacks version.{c,h} files
SRC_URI+=" https://github.com/Atoptool/atop/commit/42e86fcc42ce60f8c92f3c7d5f3a6ccde47c0b33.patch -> ${PN}-2.3.0-version_h.patch"
SRC_URI+=" https://github.com/Atoptool/atop/commit/a8d850d06efc8d70a19f55ec93fe83df51e99077.patch -> ${PN}-2.3.0-version_c.patch"
SRC_URI+=" https://github.com/Atoptool/atop/commit/5f101e656a24271726d1e9cd672631b6033c36c1.patch -> ${PN}-2.3.0-netatop_h.patch"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm ~arm64 hppa ~mips ppc ~ppc64 x86 ~amd64-linux ~x86-linux"
IUSE=""

RDEPEND="
	sys-libs/ncurses:0=
	>=sys-process/acct-6.6.4-r1
"
DEPEND="
	${RDEPEND}
	virtual/pkgconfig
"

PATCHES=(
	"${FILESDIR}"/${PN}-2.2-build.patch
	"${FILESDIR}"/${PN}-2.2-sysmacros.patch #580372

	# taken from upstream.
	"${DISTDIR}"/${P}-version_{h,c}.patch
	"${DISTDIR}"/${P}-netatop_h.patch
)

pkg_pretend() {
	if use kernel_linux ; then
		CONFIG_CHECK="~BSD_PROCESS_ACCT"
		check_extra_config
	fi
}

src_prepare() {
	default
	tc-export CC PKG_CONFIG
	sed -i 's: root : :' atop.cronsysv || die #191926
	# prefixify
	sed -i "s:/\(usr\|etc\|var\):${EPREFIX}/\1:g" Makefile || die
}

src_install() {
	emake DESTDIR="${D}" genericinstall
	# useless -${PV} copies ?
	rm "${ED%/}"/usr/bin/atop*-${PV} || die
	newinitd "${FILESDIR}"/${PN}.rc-r2 ${PN}
	newinitd "${FILESDIR}"/atopacct.rc atopacct
	systemd_dounit "${FILESDIR}"/${PN}.service
	systemd_dounit "${FILESDIR}"/atopacct.service
	dodoc atop.cronsysv AUTHOR README
}
