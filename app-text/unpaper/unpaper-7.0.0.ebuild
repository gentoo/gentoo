# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit meson

if [[ ${PV} == *9999 ]]; then
	EGIT_REPO_URI="https://github.com/Flameeyes/unpaper.git"
	inherit git-r3
else
	SRC_URI="https://www.flameeyes.eu/files/${P}.tar.xz"
	KEYWORDS="amd64 ~arm64 x86"
fi

DESCRIPTION="Post-processor for scanned and photocopied book pages"
HOMEPAGE="https://www.flameeyes.eu/projects/unpaper"

LICENSE="GPL-2"
SLOT="0"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND=">=media-video/ffmpeg-2:0=[encode]"
DEPEND="${RDEPEND}"
BDEPEND="
	app-text/docbook-xsl-ns-stylesheets
	dev-libs/libxslt
	dev-python/sphinx
	test? ( dev-python/pytest )
"
