# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="X keyboard configuration database"
HOMEPAGE="https://www.freedesktop.org/wiki/Software/XKeyboardConfig https://gitlab.freedesktop.org/xkeyboard-config/xkeyboard-config"

if [[ ${PV} == 9999 ]]; then
	EGIT_REPO_URI="https://gitlab.freedesktop.org/xkeyboard-config/xkeyboard-config.git"
	inherit autotools git-r3
	# x11-misc/util-macros only required on live ebuilds
	LIVE_DEPEND=">=x11-misc/util-macros-1.18"
else
	SRC_URI="https://www.x.org/releases/individual/data/${PN}/${P}.tar.bz2"
	KEYWORDS="alpha amd64 arm arm64 hppa ia64 ~mips ppc ppc64 ~s390 ~sh sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos ~sparc-solaris ~x86-solaris"
fi

LICENSE="MIT"
SLOT="0"
IUSE=""

BDEPEND="
	dev-util/intltool
	sys-devel/gettext
	virtual/pkgconfig
"
RDEPEND="
	!<x11-apps/xkbcomp-1.2.3
	!<x11-libs/libX11-1.4.3
"
DEPEND="
	${LIVE_DEPEND}
"

src_prepare() {
	default
	[[ ${PV} == 9999 ]] && eautoreconf
}

src_configure() {
	local econfargs=(
		--with-xkb-base="${EPREFIX}/usr/share/X11/xkb"
		--enable-compat-rules
		# do not check for runtime deps
		--disable-runtime-deps
		--with-xkb-rules-symlink=xorg
	)

	econf "${econfargs[@]}"
}
