# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python2_7 )

inherit fdo-mime python-single-r1

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
	>=dev-python/pygtk-2[${PYTHON_USEDEP}]
	sys-apps/coreutils
	virtual/cdrtools
	dvdr? ( app-cdr/dvd+rw-tools )
	mp3? ( media-sound/mpg123 )
	ogg? ( media-sound/vorbis-tools )
	vcd? (
		app-cdr/cdrdao
		media-video/vcdimager
	)"

DOCS=( CHANGELOG TRANSLATORS )

src_prepare() {
	python_fix_shebang recorder

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
