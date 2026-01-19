# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools

DESCRIPTION="Translator between english, polish, and german using Collins dictionary"
HOMEPAGE="https://github.com/wojtekka/ydpdict"
SRC_URI="https://github.com/wojtekka/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="amd64 ~riscv x86"
IUSE="ao"

RDEPEND="
	app-dicts/libydpdict
	sys-libs/ncurses:=[unicode(+)]
	ao? ( media-libs/libao )
"
DEPEND="
	${RDEPEND}
"
BDEPEND="
	virtual/pkgconfig
"

PATCHES=(
	"${FILESDIR}"/${PN}-1.0.3-tinfo.patch
)

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	econf \
		$(use_with ao libao)
}

src_install() {
	dodir "/etc"
	default
}

pkg_postinst() {
	echo
	elog "Note that to use this program you'll need the original Collins Dictionary"
	elog "datafiles (dict100.*, dict101.*). These can be found in the Dabasase/"
	elog "directory of the Windows version of the Collins dictionary. Once you obtain"
	elog "the files, put them into /usr/share/ydpdict"
	elog
	elog "Some configuration options can be set in /etc/ydpdict.conf"
	echo
}
