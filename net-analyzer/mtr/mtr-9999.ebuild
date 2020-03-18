# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit autotools fcaps flag-o-matic git-r3

DESCRIPTION="My TraceRoute, an Excellent network diagnostic tool"
HOMEPAGE="https://www.bitwizard.nl/mtr/"
EGIT_REPO_URI="https://github.com/traviscross/mtr"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE="gtk ipv6 ncurses"

RDEPEND="
	gtk? (
		dev-libs/glib:2
		x11-libs/gtk+:3
	)
	ncurses? ( sys-libs/ncurses:0= )
"
DEPEND="
	${RDEPEND}
	sys-devel/autoconf
	virtual/pkgconfig
"
DOCS=( AUTHORS FORMATS NEWS README.md SECURITY TODO )
FILECAPS=( cap_net_raw usr/sbin/mtr-packet )
PATCHES=(
	"${FILESDIR}"/${PN}-0.88-tinfo.patch
)
RESTRICT="test"

src_prepare() {
	default

	eautoreconf
}

src_configure() {
	# In the source's configure script -lresolv is commented out. Apparently it
	# is still needed for 64-bit MacOS.
	[[ ${CHOST} == *-darwin* ]] && append-libs -lresolv
	econf \
		$(use_enable ipv6) \
		$(use_with gtk) \
		$(use_with ncurses)
}

pkg_postinst() {
	fcaps_pkg_postinst

	if use prefix && [[ ${CHOST} == *-darwin* ]] ; then
		ewarn "mtr needs root privileges to run.  To grant them:"
		ewarn " % sudo chown root ${EPREFIX}/usr/sbin/mtr"
		ewarn " % sudo chmod u+s ${EPREFIX}/usr/sbin/mtr"
	fi
}
