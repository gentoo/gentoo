# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

# NOTE: Even though the *.dict.dz are the same as dictd/freedict's files,
#       their indexes seem to be in a different format. So we'll keep them
#       seperate for now.

# NOTE: Festival plugin crashes, bug 188684. Disable for now.

GNOME2_LA_PUNT=yes
GCONF_DEBUG=no

inherit eutils flag-o-matic gnome2

DESCRIPTION="A international dictionary supporting fuzzy and glob style matching"
HOMEPAGE="http://stardict-4.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}-4/${P}.tar.bz2
	pronounce? ( https://${PN}-3.googlecode.com/files/WyabdcRealPeopleTTS.tar.bz2 )
	qqwry? ( mirror://gentoo/QQWry.Dat.bz2 )"

LICENSE="CPL-1.0 GPL-3 LGPL-2"
SLOT="0"
KEYWORDS="amd64 ~arm ~arm64 ppc ppc64 sparc x86"
IUSE="espeak qqwry pronounce spell tools"

RESTRICT="test"

COMMON_DEPEND="
	>=dev-libs/glib-2.16:2
	dev-libs/libsigc++:2=
	sys-libs/zlib:=
	x11-libs/gdk-pixbuf:2
	>=x11-libs/gtk+-2.20:2
	x11-libs/libX11
	x11-libs/pango
	spell? ( >=app-text/enchant-1.2 )
	tools? (
		dev-libs/libpcre:=
		dev-libs/libxml2:=
		virtual/mysql
		)
"
RDEPEND="${COMMON_DEPEND}
	espeak? ( >=app-accessibility/espeak-1.29 )
"
DEPEND="${COMMON_DEPEND}
	app-text/docbook-xml-dtd:4.3
	app-text/gnome-doc-utils
	dev-libs/libxslt
	dev-util/intltool
	sys-devel/gettext
	virtual/pkgconfig
"

src_prepare() {
	# From Fedora
	# Remove unneeded sigc++ header files to make it sure
	# that we are using system-wide libsigc++
	# (and these does not work on gcc43)
	find dict/src/sigc++* -name \*.h -or -name \*.cc | xargs rm -f || die

	# libsigc++ started to require c++11 support
	append-cxxflags "-std=c++11"

	gnome2_src_prepare
}

src_configure() {
	# Hint: EXTRA_ECONF="--enable-gnome-support" and manual install of
	# libbonobo-2, libgnome-2, libgnomeui-2, gconf-2 and orbit-2 will
	# give you GNOME 2.x support, that is otherwise considered deprecated
	# because of the deep GNOME 2.x core library dependencies
	gnome2_src_configure \
		$(use_enable tools) \
		--disable-scrollkeeper \
		$(use_enable spell) \
		--disable-gucharmap \
		--disable-festival \
		$(use_enable espeak) \
		$(use_enable qqwry) \
		--disable-updateinfo \
		--disable-gnome-support \
		--disable-gpe-support \
		--disable-schemas-install
}

src_install() {
	gnome2_src_install

	dodoc dict/doc/{Documentation,FAQ,HACKING,HowToCreateDictionary,Skins,StarDictFileFormat,Translation}

	if use qqwry; then
		insinto /usr/share/${PN}/data
		doins ../QQWry.Dat
	fi

	if use pronounce; then
		docinto WyabdcRealPeopleTTS
		dodoc ../WyabdcRealPeopleTTS/{README,readme.txt}
		rm -f ../WyabdcRealPeopleTTS/{README,readme.txt}
		insinto /usr/share
		doins -r ../WyabdcRealPeopleTTS
	fi

	# noinst_PROGRAMS with ${PN}_ prefix from tools/src/Makefile.am wrt #292773
	if use tools; then
		local app
		local apps="${PN}-editor pydict2dic olddic2newdic oxford2dic directory2dic
			dictd2dic wquick2dic ec50 directory2treedic treedict2dir jdictionary mova
			xmlinout soothill kanjidic2 powerword kdic 21tech 21shiji buddhist
			tabfile cedict edict duden ${PN}-dict-update degb2utf frgb2utf
			jpgb2utf gmx2utf rucn kingsoft wikipedia wikipediaImage babylon
			${PN}2txt ${PN}-verify fest2dict i2e2dict downloadwiki
			ooo2dict myspell2dic exc2i2e dictbuilder tabfile2sql KangXi Unihan
			xiaoxuetang-ja wubi ydp2dict wordnet lingvosound2resdb
			resdatabase2dir dir2resdatabase ${PN}-index sd2foldoc ${PN}-text2bin
			${PN}-bin2text ${PN}-repair"

		for app in ${apps}; do
			newbin tools/src/${app} ${PN}_${app}
		done
	fi
}

pkg_postinst() {
	elog "Note: festival text to speech (TTS) plugin is not built. To use festival"
	elog 'TTS plugin, please, emerge festival and enable "Use TTS program." at:'
	elog '"Preferences -> Dictionary -> Sound" and fill in "Commandline" with:'
	elog '"echo %s | festival --tts"'
	elog
	elog "You will now need to install ${PN} dictionary files. If"
	elog "you have not, execute the below to get a list of dictionaries:"
	elog
	elog "  emerge -s ${PN}-"

	gnome2_pkg_postinst
}
