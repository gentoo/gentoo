# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit eapi9-ver optfeature

DESCRIPTION="Command-line interface to various pastebins"
HOMEPAGE="https://github.com/zlin/wgetpaste"
SRC_URI="https://github.com/zlin/wgetpaste/releases/download/${PV}/${P}.tar.xz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 ~sparc x86 ~x64-macos"
IUSE="+ssl"

PROPERTIES="test_network"
RESTRICT="test"

RDEPEND="net-misc/wget[ssl?]"

src_prepare() {
	default

	sed -i -e "s:/etc:\"${EPREFIX}\"/etc:g" wgetpaste || die
}

src_test() {
	test/test.sh || die
}

src_install() {
	dobin ${PN}
	insinto /usr/share/zsh/site-functions
	doins _wgetpaste
}

pkg_postinst() {
	optfeature "ANSI (color code) stripping support" app-text/ansifilter
	optfeature "xclip support" x11-misc/xclip

	if ver_replacing -lt '2.33-r2'; then
		ewarn
		ewarn "Sprunge is dead and the service has been dropped from the code. Remove or"
		ewarn "replace sprunge as the default service in the system or user wgetpaste"
		ewarn "config if applicable."
		ewarn
	fi
}
