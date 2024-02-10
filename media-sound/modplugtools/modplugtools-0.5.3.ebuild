# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="libmodplug based module players modplug123 and modplugplay"
HOMEPAGE="https://modplug-xmms.sourceforge.net/"
SRC_URI="mirror://sourceforge/modplug-xmms/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 x86"

RDEPEND=">=media-libs/libao-0.8.0
	>=media-libs/libmodplug-0.8.8.1
	!media-sound/modplugplay"
DEPEND="${RDEPEND}
	virtual/pkgconfig"
