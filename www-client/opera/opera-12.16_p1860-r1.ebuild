# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/www-client/opera/opera-12.16_p1860-r1.ebuild,v 1.3 2014/04/23 14:11:59 jer Exp $

EAPI=4
inherit eutils fdo-mime gnome2-utils multilib pax-utils versionator

DESCRIPTION="A fast and secure web browser and Internet suite"
HOMEPAGE="http://www.opera.com/"

SLOT="0"
LICENSE="OPERA-12 LGPL-2 LGPL-3"
KEYWORDS="amd64 x86 ~amd64-fbsd ~x86-fbsd"
IUSE="elibc_FreeBSD gtk kde +gstreamer multilib"

O_V="$(get_version_component_range 1-2)" # Version, i.e. 11.00
O_B="$(get_version_component_range 3)"   # Build number, i.e. 1156

# == Variables that often change ==
# All other variables should be accounted for by _pre/_p

O_K="noserch" # The key to the snapshot URL

O_LINGUAS="
	af ar az be bg bn cs da de el en-GB es-ES es-LA et fa fi fr fr-CA fy gd he
	hi hr hu id it ja ka kk ko lt lv me mk ms nb nl nn pa pl pt pt-BR ro ru sk
	sr sv sw ta te th tl tr uk ur uz vi zh-CN zh-TW zu
" # Supported linguas

# == End of variables that often change ==

if [[ "pre${O_B/pre/}" = "${O_B}" ]]; then	# snapshot: _pre
	HOMEPAGE="http://my.opera.com/desktopteam/blog/"

	O_D="${O_K}_${O_V}-${O_B/pre}"			# directory string
	O_P="${PN}-${O_V}-${O_B/pre}"			# package string
	O_U="http://snapshot.opera.com/unix/"	# base URI

	SRC_URI="
		amd64? ( ${O_U}${O_D}/${O_P}.x86_64.linux.tar.xz )
		amd64-fbsd? ( ${O_U}${O_D}/${O_P}.amd64.freebsd.tar.xz )
		x86? ( ${O_U}${O_D}/${O_P}.i386.linux.tar.xz )
		x86-fbsd? ( ${O_U}${O_D}/${O_P}.i386.freebsd.tar.xz )
	"
else							# release: _p
	O_D="${O_V/./}"				# directory string
	O_P="${PN}-${O_V}-${O_B/p}"	# package string
	O_U="mirror://opera/"		# base URI

	SRC_URI="
		amd64? ( ${O_U}linux/${O_D}/${O_P}.x86_64.linux.tar.xz )
		amd64-fbsd? ( ${O_U}unix/${O_D}/${O_P}.amd64.freebsd.tar.xz )
		x86? ( ${O_U}linux/${O_D}/${O_P}.i386.linux.tar.xz )
		x86-fbsd? ( ${O_U}unix/${O_D}/${O_P}.i386.freebsd.tar.xz )
	"
fi

for O_LINGUA in ${O_LINGUAS}; do
	IUSE+=" linguas_${O_LINGUA/-/_}"
done

DEPEND="
	>=sys-apps/sed-4
	app-arch/xz-utils
"
GTKRDEPEND="
	dev-libs/atk
	dev-libs/glib:2
	x11-libs/cairo
	x11-libs/gdk-pixbuf
	gtk? ( x11-libs/gtk+:2 )
	x11-libs/pango
	x11-libs/pixman
"
KDERDEPEND="
	kde-base/kdelibs
	dev-qt/qtcore:4
	dev-qt/qtgui:4
"
GSTRDEPEND="
	dev-libs/glib:2
	dev-libs/libxml2
	media-libs/gst-plugins-base:0.10
	media-libs/gstreamer:0.10
	media-plugins/gst-plugins-meta:0.10
"
RDEPEND="
	media-libs/fontconfig
	media-libs/freetype
	sys-libs/zlib
	virtual/opengl
	x11-libs/libICE
	x11-libs/libSM
	x11-libs/libX11
	x11-libs/libXext
	x11-libs/libXft
	x11-libs/libXrender
	x11-libs/libXt
	x11-misc/xdg-utils
	gtk? ( ${GTKRDEPEND} )
	kde? ( ${KDERDEPEND} )
	gstreamer? ( ${GSTRDEPEND} )
"

OPREFIX="/usr/$(get_libdir)"
QA_PREBUILT="*"

src_unpack() {
	unpack ${A}
	mv -v ${PN}* "${S}" || die
}

src_prepare() {
	local LNGDIR="share/${PN}/locale"

	# Count linguas
	count() { echo ${#}; }
	local lingua_count=$(count ${O_LINGUAS} en)
	local locale_count=$(count ${LNGDIR}/*)
	[[ ${lingua_count} = ${locale_count} ]] \
		|| die "Number of LINGUAS does not match number of locales"
	unset count

	# Remove unwanted linguas
	for LINGUA in ${O_LINGUAS}; do
		if ! use linguas_${LINGUA/-/_}; then
			LINGUA=$(find "${LNGDIR}" -maxdepth 1 -type d -iname ${LINGUA/_/-})
			rm -r "${LINGUA}" || die "The list of linguas needs to be fixed"
		fi
	done

	# Remove doc directory but keep the LICENSE under another name (bug #315473)
	mv share/doc/${PN}/LICENSE share/${PN}/defaults/license.txt
	rm -rf share/doc
	for locale in share/${PN}/locale/*; do
		rm -f "${locale}/license.txt"
		ln -sn /usr/share/${PN}/defaults/license.txt "${locale}/license.txt" \
			|| die
	done

	# Remove package directory
	rm -rf share/${PN}/package

	# Optional libraries
	if ! use gtk; then
		rm lib/${PN}/liboperagtk2.so || die
	fi
	if ! use kde; then
		rm lib/${PN}/liboperakde4.so || die
	fi
	if ! use gstreamer; then
		rm -r lib/${PN}/gstreamer || die
	fi
	if use amd64 && ! use multilib; then
		rm lib/${PN}/pluginwrapper/operapluginwrapper-ia32-linux || die
	fi

	# Unzip the man pages before sedding
	gunzip share/man/man1/* || die

	local OPERA_SUFFIX= OPERA__SUFFIX= OPERAU_SUFFIX=
	if [[ ${PN} = opera-next ]]; then
		OPERA_SUFFIX="-next"
		OPERA__SUFFIX=" Next"
		OPERA_USUFFIX="-NEXT"
	fi

	# Replace PREFIX, SUFFIX and PN in various files
	sed -i \
		-e "s:@@{PREFIX}:/usr:g" \
		-e "s:@@{SUFFIX}:${OPERA_SUFFIX}:g" \
		-e "s:@@{_SUFFIX}:${OPERA__SUFFIX}:g" \
		-e "s:@@{USUFFIX}:${OPERA_USUFFIX}:g" \
		share/man/man1/* \
		share/mime/packages/* \
		share/applications/${PN}-*.desktop \
		|| die

	# Create /usr/bin/opera wrapper
	echo '#!/bin/sh' > ${PN}
	echo 'export OPERA_DIR="/usr/share/'"${PN}"'"' >> ${PN}
	echo 'export OPERA_PERSONALDIR=${OPERA_PERSONALDIR:-"${HOME}/.'${PN}'"}' \
		>> ${PN}
	echo 'exec '"${OPREFIX}/${PN}/${PN}"' "$@"' >> ${PN}

	# Change libfreetype.so.9 to libfreetype.so.6 for Gentoo/FreeBSD, bug #477594
	if use elibc_FreeBSD; then
		scanelf -qR -N libfreetype.so.9 -F "#N" lib/${PN}/ | \
		while read i; do
			if [[ $(strings "$i" | fgrep -c libfreetype.so.9) -ne 1 ]];
			then
				export SANITY_CHECK_LIBFREETYPE_FAILED=1
				break
			fi
			sed -i \
				"$i" \
				-e 's/libfreetype\.so\.9/libfreetype.so.6/g'
		done
		[[ "$SANITY_CHECK_LIBFREETYPE_FAILED" = "1" ]] && die
	fi
}

src_install() {
	# We install into usr instead of opt as Opera does not support the latter
	dodir /usr
	if ! use elibc_FreeBSD; then
		rm lib/${PN}/opera_autoupdatechecker || die
	fi
	mv lib/ "${D}/${OPREFIX}" || die
	mv share/ "${D}/usr/" || die

	# Install startup scripts
	dobin ${PN}

	# Stop revdep-rebuild from checking opera binaries
	dodir /etc/revdep-rebuild
	echo "SEARCH_DIRS_MASK=\"${OPREFIX}/${PN}\"" \
		> "${D}"/etc/revdep-rebuild/90${PN}

	# Set PaX markings for hardened/PaX (bug #344267)
	pax-mark m $( list-paxables $( find "${D}"/${OPREFIX}/${PN}/ ) )
}

pkg_preinst() {
	gnome2_icon_savelist
}

pkg_postinst() {
	if use elibc_FreeBSD; then
		elog
		elog "To improve shared memory usage please set:"
		elog "$ sysctl kern.ipc.shm_allow_removed=1"
	fi

	# Update desktop file database and gtk icon cache (bug #334993)
	gnome2_icon_cache_update
	fdo-mime_desktop_database_update
}

pkg_postrm() {
	# Update desktop file database and gtk icon cache (bug #334993)
	gnome2_icon_cache_update
	fdo-mime_desktop_database_update
}
