# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

# NOTE: Even though the *.dict.dz are the same as dictd/freedict's files,
#       their indexes seem to be in a different format. So we'll keep them
#       seperate for now.

GNOME2_LA_PUNT=yes
PYTHON_COMPAT=( python2_7 )

inherit flag-o-matic gnome2 python-single-r1

DESCRIPTION="A international dictionary supporting fuzzy and glob style matching"
HOMEPAGE="http://stardict-4.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}-4/${P}.tar.bz2
	pronounce? ( https://${PN}-3.googlecode.com/files/WyabdcRealPeopleTTS.tar.bz2 )
	qqwry? ( mirror://gentoo/QQWry.Dat.bz2 )"

LICENSE="CPL-1.0 GPL-3 LGPL-2"
SLOT="0"
KEYWORDS="amd64 ~arm ~arm64 ppc ppc64 sparc x86"
IUSE="advertisement debug dictdotcn espeak examples +gucharmap
+htmlparse man perl +powerwordparse pronounce python qqwry spell
tools updateinfo +wikiparse +wordnet +xdxfparse"

RESTRICT="test"

COMMON_DEPEND="
	>=dev-libs/glib-2.16:2
	dev-libs/libsigc++:2=
	sys-libs/zlib:=
	x11-libs/gdk-pixbuf:2
	>=x11-libs/gtk+-2.20:2
	x11-libs/libX11
	x11-libs/pango
	gucharmap? ( gnome-extra/gucharmap:0= )
	spell? ( >=app-text/enchant-1.2 )
	tools? (
		dev-db/mysql-connector-c
		dev-libs/libpcre:=
		dev-libs/libxml2:=
		python? ( ${PYTHON_DEPS} )
	)
"
RDEPEND="${COMMON_DEPEND}
	espeak? ( >=app-accessibility/espeak-1.29 )
	perl? ( dev-lang/perl )
"
DEPEND="${COMMON_DEPEND}
	app-text/docbook-xml-dtd:4.3
	app-text/gnome-doc-utils
	dev-libs/libxslt
	dev-util/intltool
	sys-devel/gettext
	virtual/pkgconfig
"
REQUIRED_USE="tools? ( python? ( ${PYTHON_REQUIRED_USE} ) )"

# docs are messy, installed manually below
DOCS=""

src_prepare() {
	# From Fedora
	# Remove unneeded sigc++ header files to make it sure
	# that we are using system-wide libsigc++
	# (and these does not work on gcc43)
	find dict/src/sigc++* -name \*.h -or -name \*.cc | xargs rm -f || die

	# libsigc++ started to require c++11 support
	append-cxxflags "-std=c++11"

	if use python; then
		local f
		# force python shebangs handlable by python_doscript
		for f in tools/src/*.py; do
			[[ $(head -n1 "${f}") =~ ^#! ]] || continue
			sed -i '1 s|.*|#!/usr/bin/python|' tools/src/*.py || die
		done
		# script contains UTF-8 symbols, but has no ecoding set
		sed -i '1 a # -*- coding: utf-8 -*-' tools/src/uyghur2dict.py || die
	fi

	eapply_user
	gnome2_src_prepare
}

src_configure() {
	# Hint: EXTRA_ECONF="--enable-gnome-support" and manual install of
	# libbonobo-2, libgnome-2, libgnomeui-2, gconf-2 and orbit-2 will
	# give you GNOME 2.x support, that is otherwise considered deprecated
	# because of the deep GNOME 2.x core library dependencies

	# Festival plugin crashes, bug 188684. Disable for now.
	gnome2_src_configure \
		--disable-festival \
		--disable-gnome-support \
		--disable-gpe-support \
		--disable-schemas-install \
		--disable-scrollkeeper \
		$(use_enable advertisement) \
		$(use_enable debug) \
		$(use_enable dictdotcn) \
		$(use_enable espeak) \
		$(use_enable gucharmap) \
		$(use_enable htmlparse) \
		$(use_enable man) \
		$(use_enable powerwordparse) \
		$(use_enable qqwry) \
		$(use_enable spell) \
		$(use_enable tools) \
		$(use_enable updateinfo) \
		$(use_enable wikiparse) \
		$(use_enable wordnet) \
		$(use_enable xdxfparse)
}

src_install() {
	gnome2_src_install

	dodoc AUTHORS ChangeLog README

	docinto dict
	dodoc dict/{AUTHORS,ChangeLog,README,TODO}
	dodoc dict/doc/{Documentation,FAQ,HowToCreateDictionary,Skins,StarDictFileFormat,TextualDictionaryFileFormat,Translation}

	docinto lib
	dodoc lib/{AUTHORS,ChangeLog,README}

	if use examples; then
		insinto /usr/share/doc/${PF}/dict
		doins dict/doc/stardict-textual-dict*
	fi

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
	# and additional scripts from tools dir
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

		use perl && apps+=" dicts-dump.pl ncce2stardict.pl parse-oxford.perl"
		use python && apps+=" hanzim2dict.py jm2stardict.py lingea-trd-decoder.py
			makevietdict.py uyghur2dict.py"

		for app in ${apps}; do
			if [[ "${app}" =~ ^${PN} ]]; then
				dobin "tools/src/${app}"
			else
				newbin "tools/src/${app}" "${PN}_${app}"
			fi
		done
		use python && python_doscript "${ED}"usr/bin/*.py

		docinto tools
		dodoc tools/{AUTHORS,ChangeLog,README}

		if use examples; then
			insinto /usr/share/doc/${PF}/tools
			doins tools/src/{dictbuilder.{example,readme},example.ifo,example_treedict.tar.bz2}
		fi
	fi
}

pkg_postinst() {
	elog
	elog "Note: festival text to speech (TTS) plugin is not built. To use festival"
	elog 'TTS plugin, please, emerge festival and enable "Use TTS program." at:'
	elog '"Preferences -> Dictionary -> Sound" and fill in "Commandline" with:'
	elog '"echo %s | festival --tts"'
	elog
	elog "You will now need to install ${PN} dictionary files. If"
	elog "you have not, execute the below to get a list of dictionaries:"
	elog "  emerge -s ${PN}-"
	elog
	elog "Additionally you may install any stardict dictionary from the net"
	elog "by unpacking it to:"
	elog "  /usr/share/stardict/dic"
	elog

	gnome2_pkg_postinst
}
