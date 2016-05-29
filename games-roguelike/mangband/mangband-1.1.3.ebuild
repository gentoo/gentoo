# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
inherit eutils flag-o-matic user

DESCRIPTION="Online multiplayer real-time roguelike game, derived from Angband."
HOMEPAGE="http://www.mangband.org"
SRC_URI="http://www.mangband.org/download/${P}.tar.gz"

#RESTRICT=nomirror # for ebuild debugging

LICENSE="Moria"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="ncurses sdl X"

# Remove this once we hit MAngband 1.2:
S="${WORKDIR}/${P}"/src

RDEPEND="
	ncurses? ( sys-libs/ncurses:= )
	sdl? ( media-libs/libsdl )
	X? ( x11-libs/libX11 )"
DEPEND="${RDEPEND}"

PATCHES=( "${FILESDIR}/${P}-strchr.patch"
	  "${FILESDIR}/${P}-paths.patch" )

MY_DATADIR=/usr/share/"${PN}"
MY_STATEDIR=/var/lib/"${PN}"
MY_SYSCONFDIR=/etc

src_configure() {
	append-cflags "-DDEFAULT_PATH='\"${MY_DATADIR}\"' -DDEFAULT_PATH_W='\"${MY_STATEDIR}\"'"
	econf \
		$(use_with ncurses gcu) \
		$(use_with X x11) \
		$(use_with sdl)
}

pkg_setup() {
	# mangband server uses own user/group:
	enewgroup mangband
	enewuser mangband -1 -1 -1 "mangband"
}

src_install() {
# Newer versions of MAngband have "make install", so we could use..
#    emake DESTDIR="${D}" install
#    dodoc NEWS README INSTALL AUTHORS
#..but not yet

	dobin mangband mangclient

	# Read-only data
	insinto "${MY_DATADIR}"
	doins -r "${WORKDIR}/${P}"/lib/{edit,file,help,text,xtra,user}

	# Server config
	insinto "${MY_SYSCONFDIR}"
	doins "${WORKDIR}/${P}"/mangband.cfg

	# Read-write data
	insinto "${MY_STATEDIR}"
	doins -r "${WORKDIR}/${P}"/lib/{data,save,user}

	fowners -R mangband:mangband "${MY_STATEDIR}"/{data,save,user}
	fperms -R 2664 "${MY_STATEDIR}"/{data,save,user}
	fperms 2775 "${MY_STATEDIR}"/{data,save,user}

	# Docs
	#dodoc ${WORKDIR}/${P}/LICENSE
}

pkg_postinst() {
	echo
	elog "Make sure LibDir is either unset in ~/.mangrc or points to"
	elog " ${MY_DATADIR} for 'mangclient' to pick it up."
	elog "Server binary is called 'mangband', and must be run under user"
	elog " mangband, i.e. 'sudo -u mangband mangband' "
	echo
}
