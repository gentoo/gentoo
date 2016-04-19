# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

PYTHON_COMPAT=( python2_7 )
DISTUTILS_SINGLE_IMPL=true

inherit fdo-mime distutils-r1

DESCRIPTION='A hierarchical note taking application'
HOMEPAGE='http://www.giuspen.com/cherrytree'
LICENSE='GPL-3'

SLOT='0'
SRC_URI="https://github.com/giuspen/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

KEYWORDS='~amd64 ~x86'
IUSE='nls'

RDEPEND="
	x11-libs/libX11
	dev-python/dbus-python[${PYTHON_USEDEP}]
	dev-python/pyenchant[${PYTHON_USEDEP}]
	>=dev-python/pygtk-2.16:2[${PYTHON_USEDEP}]
	dev-python/pygtksourceview:2[${PYTHON_USEDEP}]
"
DEPEND="${RDEPEND}
	nls? ( sys-devel/gettext )
"

PLOCALES='cs de es fr hy it ja lt nl pl pt_BR ru sl tr uk zh_CN'
inherit l10n

python_prepare_all() {
	if use nls ; then
		l10n_find_plocales_changes 'locale' '' '.po'

		rm_loc() {
			rm -v -f "locale/${1}.po" || return 1
		}
		l10n_for_each_disabled_locale_do rm_loc
	fi

	sed -i '\|update-desktop-database|d' 'setup.py' || die

	distutils-r1_python_prepare_all
}

python_configure_all() {
	use nls || mydistutilsargs+=( '--without-gettext' )
}

pkg_postinst() {
	fdo-mime_desktop_database_update
	fdo-mime_mime_database_update
}
