# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

PYTHON_COMPAT=( python2_7 )
PLOCALES="no sl sv"

inherit bash-completion-r1 cmake-utils fdo-mime l10n python-single-r1

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
	cdemu-daemon? ( app-cdr/cdemu-daemon:0/7 )"
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
	eapply -p2 "${FILESDIR}/${PN}-3.0.0-bash-completion-dir.patch"
	eapply_user
}

src_configure() {
	DOCS="AUTHORS README"
	local mycmakeargs=(
		-DPOST_INSTALL_HOOKS=OFF
		-DGENTOO_BASHCOMPDIR="$(get_bashcompdir)"
	)
	cmake-utils_src_configure
}

src_install() {
	cmake-utils_src_install
	# Build system doesn't respect LINGUAS, and changing list of installed
	# translations requires error-prone editing of CMakeLists.txt
	rm_po() {
		rm -r "${ED}"/usr/share/locale/$1 || die
		ls "${ED}"/usr/share/locale/* &> /dev/null || rmdir "${ED}"/usr/share/locale || die
	}
	l10n_for_each_disabled_locale_do rm_po
}

pkg_postinst() {
	fdo-mime_desktop_database_update
}

pkg_postrm() {
	fdo-mime_desktop_database_update
}
