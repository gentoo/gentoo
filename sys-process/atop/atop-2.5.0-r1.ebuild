# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit linux-info systemd toolchain-funcs

DESCRIPTION="Resource-specific view of processes"
HOMEPAGE="https://www.atoptool.nl/ https://github.com/Atoptool/atop"
SRC_URI="https://github.com/Atoptool/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~mips ~ppc ~ppc64 ~x86 ~amd64-linux ~x86-linux"
IUSE=""

RDEPEND="
	sys-libs/ncurses:0=
	>=sys-process/acct-6.6.4-r1
"
DEPEND="
	${RDEPEND}
"
BDEPEND="
	virtual/pkgconfig
"

PATCHES=(
	"${FILESDIR}"/${PN}-2.4.0-build.patch
	"${FILESDIR}"/${PN}-2.5.0-install_fix.patch

	# taken from upstream.
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
	rm "${ED}"/usr/bin/atop*-${PV} || die

	newinitd "${FILESDIR}"/${PN}.rc-r2 ${PN}
	newinitd "${FILESDIR}"/atopacct.rc atopacct

	systemd_dounit "${FILESDIR}"/${PN}.service
	systemd_dounit "${FILESDIR}"/atopacct.service

	dodoc atop.cronsysv AUTHOR README

	exeinto /usr/share/${PN}
	doexe ${PN}.daily

	insinto /etc/default
	newins ${PN}{.default,}

	keepdir /var/log/${PN}
}
