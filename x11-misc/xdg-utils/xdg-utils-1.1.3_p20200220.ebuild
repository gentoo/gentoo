# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit autotools

EGIT_COMMIT="9816ebb3e6fd9f23e993b8b7fcbd56f92d9c9197"
DESCRIPTION="Portland utils for cross-platform/cross-toolkit/cross-desktop interoperability"
HOMEPAGE="https://www.freedesktop.org/wiki/Software/xdg-utils/"
SRC_URI="
	https://gitlab.freedesktop.org/xdg/xdg-utils/-/archive/${EGIT_COMMIT}/${P}.tar.bz2"
S=${WORKDIR}/xdg-utils-${EGIT_COMMIT}

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sparc ~x86 ~amd64-linux ~x86-linux ~x86-macos ~x64-solaris"
IUSE="doc"

RDEPEND="
	dev-util/desktop-file-utils
	dev-perl/File-MimeInfo
	dev-perl/Net-DBus
	dev-perl/X11-Protocol
	sys-apps/dbus
	x11-misc/shared-mime-info
	x11-apps/xprop
	x11-apps/xset
"
BDEPEND=">=app-text/xmlto-0.0.26-r1[text(+)]"

DOCS=( ChangeLog README RELEASE_NOTES TODO )

# Tests run random system programs, including interactive programs
# that block forever
RESTRICT="test"

src_prepare() {
	default
	# If you choose to do git snapshot instead of patchset, you need to remember
	# to run `autoconf` in ./ and `make scripts-clean` in ./scripts/ to refresh
	# all the files
	eautoreconf
}

src_configure() {
	export ac_cv_path_XMLTO="$(type -P xmlto) --skip-validation" #502166
	default
	emake -C scripts scripts-clean
}

src_install() {
	default

	newdoc scripts/xsl/README README.xsl
	use doc && dodoc -r scripts/html

	# Install default XDG_DATA_DIRS, bug #264647
	echo XDG_DATA_DIRS=\"${EPREFIX}/usr/local/share\" > 30xdg-data-local
	echo 'COLON_SEPARATED="XDG_DATA_DIRS XDG_CONFIG_DIRS"' >> 30xdg-data-local
	doenvd 30xdg-data-local

	echo XDG_DATA_DIRS=\"${EPREFIX}/usr/share\" > 90xdg-data-base
	echo XDG_CONFIG_DIRS=\"${EPREFIX}/etc/xdg\" >> 90xdg-data-base
	doenvd 90xdg-data-base
}

pkg_postinst() {
	[[ -x $(type -P gtk-update-icon-cache) ]] \
		|| elog "Install dev-util/gtk-update-icon-cache for the gtk-update-icon-cache command."
}
