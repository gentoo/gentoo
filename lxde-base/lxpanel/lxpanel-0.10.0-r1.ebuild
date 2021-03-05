# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PLOCALES="af ar be bg bn_IN bn ca cs da de el en_GB es et eu fa fi fo fr frp
gl he hr hu id is it ja kk km ko lg lt lv ml ms nb nl nn pa pl ps pt_BR pt ro
ru sk sl sr@latin sr sv te th tr tt_RU ug uk ur_PK ur vi zh_CN zh_HK zh_TW"

PLOCALE_BACKUP="en_GB"

inherit l10n readme.gentoo-r1

DESCRIPTION="Lightweight X11 desktop panel for LXDE"
HOMEPAGE="https://wiki.lxde.org/en/LXPanel"
SRC_URI="mirror://sourceforge/lxde/${P}.tar.xz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ppc x86 ~amd64-linux ~x86-linux"
IUSE="+alsa wifi"

RDEPEND="dev-libs/keybinder:0=
	x11-libs/gtk+:2
	>=x11-libs/libfm-1.2.0[gtk]
	x11-libs/libwnck:1
	x11-libs/libXmu
	x11-libs/libXpm
	x11-libs/cairo
	x11-libs/gdk-pixbuf
	x11-libs/libX11
	lxde-base/lxmenu-data
	lxde-base/menu-cache
	alsa? ( media-libs/alsa-lib )
	wifi? ( net-wireless/wireless-tools )"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	sys-devel/gettext"

DOC_CONTENTS="If you have problems with broken icons shown in the main panel,
you will have to configure panel settings via its menu.
This will not be an issue with first time installations."

PATCHES=(
	"${FILESDIR}"/${PN}-remove-gdk-pixbuf-xlib.patch
)

src_prepare() {
	default

	export LINGUAS="${LINGUAS:-${PLOCALE_BACKUP}}"
	l10n_get_locales > po/LINGUAS || die
}

src_configure() {
	local plugins="netstatus,volume,cpu,deskno,batt, \
		kbled,xkb,thermal,cpufreq,monitors"

	use wifi && plugins+=",netstat"
	use alsa && plugins+=",volumealsa"
	[[ ${CHOST} == *-interix* ]] && plugins=deskno,kbled,xkb

	econf $(use_enable alsa) --with-x --with-plugins="${plugins}"
	# the gtk+ dep already pulls in libX11, so we might as well hardcode with-x
}

src_install() {
	default

	# Get rid of the .la files.
	find "${D}" -name '*.la' -delete

	readme.gentoo_create_doc
}

pkg_postinst() {
	readme.gentoo_print_elog
}
