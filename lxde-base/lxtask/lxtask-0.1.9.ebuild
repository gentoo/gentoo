# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PLOCALES="af ar ast be bg bn_IN bn ca cs da de el en_GB es et eu fa fi fo fr
frp gl he hr hu id is it ja kk ko lg lt lv ml ms nb nl nn pa pl ps pt_BR pt
ro ru sk sl sq sr@latin sr sv te th tr tt_RU ug uk ur_PK ur vi zh_CN zh_TW"

PLOCALE_BACKUP="en_GB"

inherit l10n

DESCRIPTION="LXDE Task manager"
HOMEPAGE="https://wiki.lxde.org/en/LXTask"
SRC_URI="mirror://sourceforge/lxde/${P}.tar.xz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 arm ~arm64 ppc x86 ~x86-linux"
IUSE=""

RDEPEND="x11-libs/gtk+:2
	dev-libs/glib:2"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	sys-devel/gettext
	>=dev-util/intltool-0.40.0"

# Upstream report:
# https://sourceforge.net/p/lxde/patches/535/
PATCHES=( "${FILESDIR}/lxtask-0.1.7-fix-no-common.patch" )

src_prepare() {
	default

	export LINGUAS="${LINGUAS:-${PLOCALE_BACKUP}}"
	l10n_get_locales > po/LINGUAS || die
}
