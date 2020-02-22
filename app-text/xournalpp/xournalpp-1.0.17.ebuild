# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake-utils xdg

if [[ ${PV} == *9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/xournalpp/xournalpp.git"
	unset SRC_URI
else
	KEYWORDS="~amd64"
	SRC_URI="https://github.com/xournalpp/xournalpp/archive/${PV}.tar.gz -> ${P}.tgz"
fi

DESCRIPTION="Handwriting notetaking software with PDF annotation support"
HOMEPAGE="https://github.com/xournalpp/xournalpp"

LICENSE="GPL-2"
SLOT="0"
IUSE=""

COMMONDEPEND="
	app-text/poppler
	dev-libs/glib
	dev-libs/libxml2
	dev-libs/libzip:=
	media-libs/portaudio
	media-libs/libsndfile
	sys-libs/zlib:=
	x11-libs/gtk+:3
"
RDEPEND="${COMMONDEPEND}
"
DEPEND="${COMMONDEPEND}
"
BDEPEND="
	virtual/pkgconfig
	sys-apps/lsb-release
"

PATCHES=(
	"${FILESDIR}/${P}-translations.patch"
)

src_prepare() {
	cmake-utils_src_prepare
}
