# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

DESCRIPTION="A curses-based client for Tox."
HOMEPAGE="https://github.com/JFreegman/toxic"
SRC_URI="https://github.com/JFreegman/toxic/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+X +av notifications"

RDEPEND="
	net-libs/tox[av?]
	dev-libs/libconfig
	media-gfx/qrencode
	net-misc/curl
	sys-libs/ncurses:0=
	av? ( media-libs/openal media-libs/freealut )
	notifications? ( x11-libs/libnotify )
"
DEPEND="${RDEPEND}"

src_configure() {
	if ! use av; then
		export DISABLE_AV=1
		export DISABLE_SOUND_NOTIFY=1
	fi
	if ! use X; then
		export DISABLE_X11=1
	fi
	if ! use notifications; then
		export DISABLE_DESKTOP_NOTIFY=1
	fi
	sed -i \
		-e "s,/usr/local,${EPREFIX}/usr,g" \
		cfg/global_vars.mk || die "PREFIX sed failed"
}

src_install() {
	default
	if ! use av; then
		rm -r "${ED%/}"/usr/share/${PN}/sounds || die "Could not remove sound dir"
	fi
}
