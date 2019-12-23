# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake

DESCRIPTION="A Pulseaudio mixer in Qt (port of pavucontrol)"
HOMEPAGE="https://lxqt.org/"

if [[ ${PV} = *9999* ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/lxqt/${PN}.git"
else
	SRC_URI="https://downloads.lxqt.org/downloads/${PN}/${PV}/${P}.tar.xz"
	KEYWORDS="amd64 ~arm ~arm64 ~hppa x86"
fi

LICENSE="GPL-2+"
SLOT="0"

BDEPEND="
	dev-qt/linguist-tools:5
	>=dev-util/lxqt-build-tools-0.6.0
	virtual/pkgconfig
"
DEPEND="
	dev-libs/glib:2
	dev-qt/qtcore:5
	dev-qt/qtdbus:5
	dev-qt/qtwidgets:5
	media-sound/pulseaudio[glib]
"
RDEPEND="${DEPEND}
	!lxqt-base/lxqt-l10n
"
