# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit autotools flag-o-matic git-r3 toolchain-funcs versionator

DESCRIPTION="Practical Music Search: an open source ncurses client for mpd, written in C++"
HOMEPAGE="https://ambientsound.github.io/pms"
EGIT_REPO_URI="https://github.com/ambientsound/pms.git"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS=""
IUSE="regex doc"

RDEPEND="
	sys-libs/ncurses:0=[unicode]
	dev-libs/glib:2
	media-libs/libmpdclient
	virtual/libintl
"
DEPEND="
	virtual/pkgconfig
	dev-util/intltool
	sys-devel/gettext
	doc? ( app-text/pandoc )
	${RDEPEND}
"

DOCS=( AUTHORS README TODO )

pkg_pretend() {
	if [[ ${MERGE_TYPE} != binary ]] && use regex; then
		if tc-is-gcc && ! version_is_at_least 4.9 $(gcc-version); then
			die "Clang or GCC >= 4.9 is required for proper regex support"
		fi
	fi
}

src_prepare() {
	eapply "${FILESDIR}/pms-9999-fix-automagic-dep.patch"
	eapply_user

	eautoreconf
}

src_configure() {
	# Required for ncurses[tinfo]
	append-cppflags $($(tc-getPKG_CONFIG) --cflags ncursesw)
	append-libs $($(tc-getPKG_CONFIG) --libs ncursesw)

	econf \
		$(use_enable regex) \
		$(use_with doc)
}
