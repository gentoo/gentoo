# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$
EAPI=5

inherit eutils

DESCRIPTION="Perl script to colorise the gcc output."
HOMEPAGE="http://schlueters.de/colorgcc.html"
SRC_URI="mirror://gentoo/${P}.tar.gz"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="alpha amd64 hppa mips ppc sparc x86 ~x86-interix ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos"
IUSE=""

DEPEND="dev-lang/perl"
RDEPEND="${DEPEND}"

PATCHES=(
	"${FILESDIR}"/${P}-gentoo-one.patch
	"${FILESDIR}"/${P}-gentoo-two.patch
	"${FILESDIR}"/${P}-note.patch
	"${FILESDIR}"/${P}-nohang.patch
)

src_prepare() {
	epatch "${PATCHES[@]}"
}

src_install() {
	dobin "${PN}"
	dodir "/etc/${PN}" "/usr/lib/${PN}/bin"
	insinto "/etc/${PN}"
	doins "${PN}rc"
	einfo "Scanning for compiler front-ends"
	into "/usr/lib/${PN}/bin"
	local COMPILERS=( gcc cc c++ g++ ${CHOST}-gcc ${CHOST}-c++ ${CHOST}-g++ )
	for c in "${COMPILERS[@]}"; do
		[[ -n "$(type -p ${c})" ]] && \
			dosym "/usr/bin/${PN}" "/usr/lib/${PN}/bin/${c}"
	done

	dodoc CREDITS ChangeLog
}

pkg_postinst() {
	echo
	elog "If you have existing \$HOME/.colorgccrc files that set the location"
	elog "of the compilers, you should remove those lines for maximum"
	elog "flexibility.  The colorgcc script now knows how to pass the command"
	elog "on to the next step in the PATH without manual tweaking, making it"
	elog "easier to use with things like ccache and distcc on a conditional"
	elog "basis.  You can tweak the /etc/colorgcc/colorgccrc file to change"
	elog "the default settings for everyone (or copy this file as a basis for"
	elog "a custom \$HOME/.colorgccrc file)."
	elog
	elog "NOTE: the symlinks for colorgcc are now located in"
	elog "/usr/lib/colorgcc/bin *NOT* /usr/bin/wrappers.  You'll need to"
	elog "change any PATH settings that referred to the old location."
	echo

	# portage won't delete the old symlinks for users that are upgrading
	# because the old symlinks still point to /usr/bin/colorgcc which exists...
	if [[ -d "${EROOT}"/usr/bin/wrappers ]]; then
		rm -frv "${EROOT}"/usr/bin/wrappers || die
	fi
}
