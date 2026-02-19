# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools

DESCRIPTION="ncurses based mpd client with vi-like key bindings"
HOMEPAGE="https://github.com/boysetsfrog/vimpc"
if [[ ${PV} == *9999* ]] ; then
	EGIT_REPO_URI="https://github.com/boysetsfrog/${PN}.git"
	inherit git-r3
else
	COMMIT=95ad78d112316a1c290a480481fd1f8abf50b59b
	if [[ -n ${COMMIT} ]] ; then
		SRC_URI="https://github.com/boysetsfrog/${PN}/archive/${COMMIT}.tar.gz -> ${P}-${COMMIT:0:8}.tar.gz"
		S="${WORKDIR}/${PN}-${COMMIT}"
	else
		SRC_URI="https://github.com/boysetsfrog/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	fi
	KEYWORDS="amd64 x86"
fi

LICENSE="GPL-3+"
SLOT="0"
IUSE="taglib"

RDEPEND="
	dev-libs/libpcre
	media-libs/libmpdclient
	taglib? ( media-libs/taglib:= )
"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

src_prepare() {
	default
	rm m4/m4_ax_boost* || die
	eautoreconf
}

src_configure() {
	# Tests here seem to make cppunit linked into the main vimpc binary
	# Not clear how to run them either
	econf \
		--disable-boost \
		--disable-test \
		$(use_enable taglib)
}

src_install() {
	local DOCS=( AUTHORS README.md doc/vimpcrc.example )
	default

	# vimpc will look for help.txt
	docompress -x /usr/share/doc/${PF}/help.txt
}
