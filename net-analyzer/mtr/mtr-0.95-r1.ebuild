# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools bash-completion-r1 fcaps

DESCRIPTION="My TraceRoute, an Excellent network diagnostic tool"
HOMEPAGE="https://www.bitwizard.nl/mtr/"

if [[ ${PV} == *9999* ]] ; then
	EGIT_REPO_URI="https://github.com/traviscross/mtr"
	inherit git-r3
else
	SRC_URI="https://github.com/traviscross/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~alpha amd64 arm arm64 ~hppa ~mips ppc ppc64 ~riscv ~s390 ~sparc x86 ~x64-macos"
fi

LICENSE="GPL-2"
SLOT="0"
IUSE="gtk +ipinfo +ipv6 jansson ncurses"
# TODO: This is an inherited RESTRICT - figure out why!
RESTRICT="test"

RDEPEND="
	gtk? (
		dev-libs/glib:2
		x11-libs/gtk+:3
	)
	jansson? ( dev-libs/jansson:= )
	ncurses? ( sys-libs/ncurses:= )
"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

DOCS=( AUTHORS FORMATS NEWS README.md SECURITY TODO )
FILECAPS=( cap_net_raw usr/sbin/mtr-packet )

PATCHES=(
	"${FILESDIR}"/${PN}-0.88-tinfo.patch
	"${FILESDIR}"/${P}-fortify-source-3.patch
)

src_prepare() {
	default

	eautoreconf
}

src_configure() {
	econf \
		$(use_enable ipv6) \
		$(use_with gtk) \
		$(use_with ipinfo) \
		$(use_with jansson) \
		$(use_with ncurses) \
		--with-bashcompletiondir="$(get_bashcompdir)"
}

pkg_postinst() {
	fcaps_pkg_postinst

	if use prefix && [[ ${CHOST} == *-darwin* ]] ; then
		ewarn "mtr needs root privileges to run.  To grant them:"
		ewarn " % sudo chown root ${EPREFIX}/usr/sbin/mtr"
		ewarn " % sudo chmod u+s ${EPREFIX}/usr/sbin/mtr"
	fi
}
