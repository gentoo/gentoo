# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

if [[ ${PV} == *9999 ]]; then
	EGIT_REPO_URI="https://github.com/Flameeyes/unpaper.git"
	inherit git-r3 autotools
else
	SRC_URI="https://www.flameeyes.eu/files/${P}.tar.xz"
	KEYWORDS="~amd64 ~x86"
fi

DESCRIPTION="Post-processor for scanned and photocopied book pages"
HOMEPAGE="https://www.flameeyes.eu/projects/unpaper"

LICENSE="GPL-2"
SLOT="0"
IUSE="test"

RDEPEND=">=media-video/ffmpeg-2:0=[encode]"
DEPEND="dev-libs/libxslt
	app-text/docbook-xsl-ns-stylesheets
	virtual/pkgconfig
	${RDEPEND}"

# gcc can generate slightly different code that leads to slightly different
# images. Wait until we get a better testsuite.
RESTRICT="test"

src_prepare() {
	default
	[[ ${PV} == *9999 ]] && eautoreconf
}
