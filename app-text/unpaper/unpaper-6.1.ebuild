# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-text/unpaper/unpaper-6.1.ebuild,v 1.1 2014/10/26 23:07:48 flameeyes Exp $

EAPI=5

inherit autotools-utils

if [[ ${PV} == 9999 ]]; then
	EGIT_REPO_URI="https://github.com/Flameeyes/unpaper.git"
	inherit git-2 autotools
else
	SRC_URI="https://www.flameeyes.eu/files/${P}.tar.xz"
	KEYWORDS="~amd64 ~x86"
fi

DESCRIPTION="Post-processor for scanned and photocopied book pages"
HOMEPAGE="https://www.flameeyes.eu/projects/unpaper"

LICENSE="GPL-2"

SLOT="0"
IUSE="test"

RDEPEND="|| ( >=media-video/libav-10[encode] >=media-video/ffmpeg-2[encode] )"
DEPEND="dev-libs/libxslt
	app-text/docbook-xsl-ns-stylesheets
	virtual/pkgconfig
	${RDEPEND}"

# gcc can generate slightly different code that leads to slightly different
# images. Wait until we get a better testsuite.
RESTRICT="test"

if [[ ${PV} == 9999 ]]; then
	src_prepare() {
		eautoreconf
		autotools-utils_src_prepare
	}
fi
