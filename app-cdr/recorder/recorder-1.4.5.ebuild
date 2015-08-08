# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4

PYTHON_DEPEND="2:2.7"

inherit fdo-mime python

DESCRIPTION="A simple GTK+ disc burner"
HOMEPAGE="http://code.google.com/p/recorder/"
SRC_URI="http://recorder.googlecode.com/files/${P}.tar.bz2"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="dvdr mp3 nls ogg vcd"

LANGS="ar cs es fr it nl pl pt_BR ru sv"
for l in ${LANGS}; do
	IUSE="${IUSE} linguas_${l}"
done

DEPEND="nls? ( sys-devel/gettext )"
RDEPEND="${DEPEND}
	>=dev-python/pygtk-2
	sys-apps/coreutils
	virtual/cdrtools
	dvdr? ( app-cdr/dvd+rw-tools )
	mp3? ( media-sound/mpg123 )
	ogg? ( media-sound/vorbis-tools )
	vcd? (
		app-cdr/cdrdao
		media-video/vcdimager
		)"

DOCS="CHANGELOG TRANSLATORS"

pkg_setup() {
	python_set_active_version 2
	python_pkg_setup
}

src_prepare() {
	python_convert_shebangs 2 recorder

	local MY_NLS=""
	if use nls; then
		for ling in ${LINGUAS}; do
			if has $ling ${LANGS}; then
				MY_NLS="${MY_NLS} ${ling}"
			fi
		done
	fi

	sed -i -e "s:ar cs es fr pt_BR ru it nl:${MY_NLS}:" Makefile || die
}

pkg_postinst() {
	fdo-mime_desktop_database_update
}

pkg_postrm() {
	fdo-mime_desktop_database_update
}
