# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-video/arista/arista-0.9.7.ebuild,v 1.3 2014/12/25 19:48:21 mgorny Exp $

EAPI="5"

PYTHON_COMPAT=( python2_7 )
PYTHON_REQ_USE="xml"

# hack for avoiding detecting 'templates' as a locale, next part of it - in src_prepare
PLOCALES_1="ar ast bg ca cs da de el en_GB es et eu fi fr gl hu ia id it ja jv kn lt nl pl pt pt_BR ro ru sk sl sr sv"
PLOCALES_2="th tr uk zh_CN zh_TW"
PLOCALES="${PLOCALES_1} ${PLOCALES_2}"

inherit distutils-r1 l10n

DESCRIPTION="An easy to use multimedia transcoder for the GNOME Desktop"
HOMEPAGE="http://www.transcoder.org"
SRC_URI="http://programmer-art.org/media/releases/arista-transcoder/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
# Making these USE-defaults since encoding for portable devices is a very
# common use case for Arista. xvid is being added since it's required for
# DVD ripping. No gst-plugins-x264 available at this time.
IUSE="+faac kde nautilus +x264 +xvid"

DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"
RDEPEND=">=x11-libs/gtk+-2.16:2
	>=dev-python/pygtk-2.16:2[${PYTHON_USEDEP}]
	dev-python/pygobject:2[${PYTHON_USEDEP}]
	dev-python/pycairo[${PYTHON_USEDEP}]
	dev-python/gconf-python:2
	dev-python/dbus-python[${PYTHON_USEDEP}]
	dev-python/python-gudev[${PYTHON_USEDEP}]
	gnome-base/librsvg
	>=media-libs/gstreamer-0.10.22:0.10
	dev-python/gst-python:0.10[${PYTHON_USEDEP}]
	media-libs/gst-plugins-base:0.10
	media-libs/gst-plugins-good:0.10
	media-libs/gst-plugins-bad:0.10
	media-plugins/gst-plugins-meta:0.10
	media-plugins/gst-plugins-ffmpeg:0.10
	x11-themes/gnome-icon-theme
	nautilus? ( dev-python/nautilus-python[${PYTHON_USEDEP}] )
	kde? ( dev-python/librsvg-python[${PYTHON_USEDEP}] )
	faac? ( media-plugins/gst-plugins-faac:0.10 )
	x264? ( media-plugins/gst-plugins-x264:0.10 )
	xvid? ( media-plugins/gst-plugins-xvid:0.10 )"

PATCHES=( "${FILESDIR}/${P}-doc-install.patch" )

src_prepare() {
	# dirty hack for new locale detection
	local PLOCALES="${PLOCALES_1} templates ${PLOCALES_2}"
	l10n_find_plocales_changes "${S}/locale" "" ""

	distutils-r1_src_prepare
}

src_install() {
	remove_unused_locale() {
		rm -r "${ED}/usr/share/locale/${1}" || die "can not remove unused locale '${1}'"
	}

	distutils-r1_src_install

	l10n_for_each_disabled_locale_do remove_unused_locale
}

pkg_postinst() {
	einfo "If you find that a format you want is not supported in Arista,"
	einfo "please make sure that you have the corresponding USE-flag enabled"
	einfo "media-plugins/gst-plugins-meta"
}
