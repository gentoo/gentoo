# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PLOCALES="af ar ast be bg bn_IN bn ca cs da de el en_GB es et eu fa fi fo
fr frp gl he hr hu id is ja kk ko lg lt ml ms nb nl nn pa pl ps pt_BR pt
ro ru sk sl sr@latin sr sv te th tr tt_RU ug uk ur_PK ur vi zh_CN zh_TW"

PLOCALE_BACKUP="en_GB"

inherit l10n

DESCRIPTION="LXDE GUI interface to RandR extention"
HOMEPAGE="https://wiki.lxde.org/en/LXRandR"
SRC_URI="mirror://sourceforge/lxde/${P}.tar.xz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 arm ~arm64 ppc x86 ~x86-linux"
IUSE=""

RDEPEND="x11-libs/gtk+:2
	x11-libs/libXrandr
	x11-apps/xrandr"
DEPEND="${RDEPEND}
	>=dev-util/intltool-0.40.0
	sys-devel/gettext
	virtual/pkgconfig
	x11-base/xorg-proto"

src_prepare() {
	default
	export LINGUAS="${LINGUAS:-${PLOCALE_BACKUP}}"
	l10n_get_locales > po/LINGUAS || die
}
