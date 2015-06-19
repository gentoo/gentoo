# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/eclass/mythtv-plugins.eclass,v 1.40 2011/08/22 04:46:32 vapier Exp $

# @ECLASS: mythtv-plugins.eclass
# @MAINTAINER:
# Doug Goldstein <cardoe@gentoo.org>
# @AUTHOR:
# Doug Goldstein <cardoe@gentoo.org>
# @BLURB: Installs MythTV plugins along with patches from the release-${PV}-fixes branch

# NOTE: YOU MUST INHERIT EITHER qt3 or qt4 IN YOUR PLUGIN!

inherit mythtv multilib versionator

# Extra configure options to pass to econf
MTVCONF=${MTVCONF:=""}

SLOT="0"
IUSE="${IUSE} debug mmx"

if [[ -z $MYTHTV_NODEPS ]] ; then
RDEPEND="${RDEPEND}
		=media-tv/mythtv-${MY_PV}*"
DEPEND="${DEPEND}
		=media-tv/mythtv-${MY_PV}*
		>=sys-apps/sed-4"
fi

# bug 240325
RESTRICT="strip"

mythtv-plugins_pkg_setup() {
	# List of available plugins (needs to include ALL of them in the tarball)
	MYTHPLUGINS="mythbrowser mythcontrols mythdvd mythflix mythgallery"
	MYTHPLUGINS="${MYTHPLUGINS} mythgame mythmusic mythnews mythphone"
	MYTHPLUGINS="${MYTHPLUGINS} mythvideo mythweather mythweb"

	if version_is_at_least "0.20" ; then
		MYTHPLUGINS="${MYTHPLUGINS} mytharchive"
	fi

	if version_is_at_least "0.21_beta" ; then
		MYTHPLUGINS="${MYTHPLUGINS} mythzoneminder mythmovies"
		MYTHPLUGINS="${MYTHPLUGINS/mythdvd/}"
	fi

	if version_is_at_least "0.22_beta" ; then
		MYTHPLUGINS="${MYTHPLUGINS/mythcontrols/}"
		MYTHPLUGINS="${MYTHPLUGINS/mythphone/}"
	fi

	if version_is_at_least "0.23_beta" ; then
		MYTHPLUGINS="${MYTHPLUGINS/mythflix/}"
		MYTHPLUGINS="${MYTHPLUGINS} mythnetvision"
	fi
}

mythtv-plugins_src_prepare() {
	sed -e 's!PREFIX = /usr/local!PREFIX = /usr!' \
	-i 'settings.pro' || die "fixing PREFIX to /usr failed"

	sed -e "s!QMAKE_CXXFLAGS_RELEASE = -O3 -march=pentiumpro -fomit-frame-pointer!QMAKE_CXXFLAGS_RELEASE = ${CXXFLAGS}!" \
	-i 'settings.pro' || die "Fixing QMake's CXXFLAGS failed"

	sed -e "s!QMAKE_CFLAGS_RELEASE = \$\${QMAKE_CXXFLAGS_RELEASE}!QMAKE_CFLAGS_RELEASE = ${CFLAGS}!" \
	-i 'settings.pro' || die "Fixing Qmake's CFLAGS failed"

	find "${S}" -name '*.pro' -exec sed -i \
		-e "s:\$\${PREFIX}/lib/:\$\${PREFIX}/$(get_libdir)/:g" \
		-e "s:\$\${PREFIX}/lib$:\$\${PREFIX}/$(get_libdir):g" \
	{} \;
}

mythtv-plugins_src_configure() {
	cd "${S}"

	if use debug; then
		sed -e 's!CONFIG += release!CONFIG += debug!' \
		-i 'settings.pro' || die "switching to debug build failed"
	fi

#	if ( use x86 && ! use mmx ) || ! use amd64 ; then
	if ( ! use mmx ); then
		sed -e 's!DEFINES += HAVE_MMX!DEFINES -= HAVE_MMX!' \
		-i 'settings.pro' || die "disabling MMX failed"
	fi

	local myconf=""

	if has ${PN} ${MYTHPLUGINS} ; then
		for x in ${MYTHPLUGINS} ; do
			if [[ ${PN} == ${x} ]] ; then
				myconf="${myconf} --enable-${x}"
			else
				myconf="${myconf} --disable-${x}"
			fi
		done
	else
		die "Package ${PN} is unsupported"
	fi

	chmod +x configure
	econf ${myconf} ${MTVCONF}
}

mythtv-plugins_src_compile() {
	if version_is_at_least "0.22" ; then
		eqmake4 mythplugins.pro || die "eqmake4 failed"
	else
		eqmake3 mythplugins.pro || die "eqmake3 failed"
	fi
	emake || die "make failed to compile"
}

mythtv-plugins_src_install() {
	if has ${PN} ${MYTHPLUGINS} ; then
		cd "${S}"/${PN}
	else
		die "Package ${PN} is unsupported"
	fi

	einstall INSTALL_ROOT="${D}"
	for doc in AUTHORS COPYING FAQ UPGRADING ChangeLog README; do
		test -e "${doc}" && dodoc ${doc}
	done
}

EXPORT_FUNCTIONS pkg_setup src_prepare src_configure src_compile src_install
