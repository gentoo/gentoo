# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

PYTHON_COMPAT=( python2_7 )

inherit fdo-mime eutils python-single-r1

DESCRIPTION='A hierarchical note taking application'
HOMEPAGE='http://www.giuspen.com/cherrytree'
LICENSE='GPL-3'

SLOT='0'
SRC_URI="https://github.com/giuspen/cherrytree/archive/${PV}.tar.gz -> ${P}.tar.gz"

KEYWORDS='~amd64'
IUSE='nls'

RDEPEND="${PYTHON_DEPS}
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

src_prepare() {
	use nls && l10n_find_plocales_changes 'locale' '' '.po'

	default
}

src_compile() {
	local args=()
	use nls || args+=( '--without-gettext' )

	"${EPYTHON}" ./setup.py "${args[@]}" build
}

src_install() {
	dobin "${PN}"

	doicon -s scalable "glade/svg/${PN}.svg"
	domenu "linux/${PN}.desktop"
	doman "linux/${PN}.1"

	insinto "/usr/share/${PN}"
	doins -r 'glade/' 'modules/' 'language-specs/'

	insinto '/usr/share/mime-info'
	doins "linux/${PN}".{mime,keys}
	insinto '/usr/share/mime/packages'
	doins "linux/${PN}.xml"

	if use nls ; then
		ins_loc() {
			# cannot use domo() as it installs files into a wrong dir
			insinto "/usr/share/locale/${1}/LC_MESSAGES"
			doins "build/mo/${1}/${PN}.mo"
		}
		l10n_for_each_locale_do ins_loc
	fi
}

pkg_postinst() {
	fdo-mime_desktop_database_update
	fdo-mime_mime_database_update
}
