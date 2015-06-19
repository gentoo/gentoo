# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-mobilephone/wammu/wammu-0.35.ebuild,v 1.5 2011/08/13 07:15:07 xarthisius Exp $

EAPI="3"

PYTHON_DEPEND="2"

inherit distutils

DESCRIPTION="Front-end for gammu to access mobile phones easily"
HOMEPAGE="http://www.wammu.eu/"
SRC_URI="http://dl.cihar.com/wammu/v0/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="bluetooth gnome"

RDEPEND=">=app-mobilephone/gammu-1.25.0[python]
	>=dev-python/wxpython-2.8
	bluetooth? ( dev-python/pybluez
		gnome? ( net-wireless/gnome-bluetooth )
	)"
DEPEND="${RDEPEND}"

# Supported languages and translated documentation
# Be sure all languages are prefixed with a single space!
MY_AVAILABLE_LINGUAS=" af bg ca cs da de el es et fi fr gl he hu id it ko nl pl pt_BR ru sk sv zh_CN zh_TW"
IUSE="${IUSE} ${MY_AVAILABLE_LINGUAS// / linguas_}"

pkg_setup() {
	python_set_active_version 2
	python_pkg_setup
}

src_prepare() {
	local lang support_linguas=no
	for lang in ${MY_AVAILABLE_LINGUAS} ; do
		if use linguas_${lang} ; then
			support_linguas=yes
			break
		fi
	done
	# install all languages when all selected LINGUAS aren't supported
	if [ "${support_linguas}" = "yes" ]; then
		for lang in ${MY_AVAILABLE_LINGUAS} ; do
			if ! use linguas_${lang} ; then
				rm -r locale/${lang} || die
			fi
		done
	fi

	python_convert_shebangs -r 2 .
}

src_compile() {
	# SKIPWXCHECK: else 'import wx' results in
	# Xlib: connection to ":0.0" refused by server
	SKIPWXCHECK=yes distutils_src_compile
}

src_install() {
	DOCS="AUTHORS FAQ"
	SKIPWXCHECK=yes distutils_src_install
}
