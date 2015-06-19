# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-cdr/cdemu/cdemu-2.1.1.ebuild,v 1.5 2015/04/08 07:30:32 mgorny Exp $

EAPI="5"

CMAKE_MIN_VERSION="2.8.5"
PYTHON_COMPAT=( python2_7 )
PLOCALES="de fr no pl sl sv"

inherit bash-completion-r1 cmake-utils eutils fdo-mime l10n python-single-r1

DESCRIPTION="Command-line tool for controlling cdemu-daemon"
HOMEPAGE="http://cdemu.org"
SRC_URI="mirror://sourceforge/cdemu/cdemu-client-${PV}.tar.bz2"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="amd64 ~hppa x86"
IUSE="+cdemu-daemon"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="${PYTHON_DEPS}
	dev-python/dbus-python[${PYTHON_USEDEP}]
	cdemu-daemon? ( app-cdr/cdemu-daemon:0/6 )"
DEPEND="${RDEPEND}
	dev-util/desktop-file-utils
	>=dev-util/intltool-0.21
	>=sys-devel/gettext-0.18"

S=${WORKDIR}/cdemu-client-${PV}

pkg_setup() {
	python-single-r1_pkg_setup
}

src_prepare() {
	python_fix_shebang src/cdemu
	epatch "${FILESDIR}/${PN}-2.1.0-bash-completion-dir.patch"
	# build system doesn't respect LINGUAS :/
	l10n_find_plocales_changes po "" ".po"
	rm_po() {
		rm po/$1.po || die
	}
	l10n_for_each_disabled_locale_do rm_po
}

src_configure() {
	DOCS="AUTHORS README"
	local mycmakeargs=(
		-DPOST_INSTALL_HOOKS=OFF
		-DGENTOO_BASHCOMPDIR="$(get_bashcompdir)"
	)
	cmake-utils_src_configure
}

pkg_postinst() {
	fdo-mime_desktop_database_update
}

pkg_postrm() {
	fdo-mime_desktop_database_update
}
