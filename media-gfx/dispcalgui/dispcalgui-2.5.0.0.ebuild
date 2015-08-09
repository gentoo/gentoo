# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"
PYTHON_COMPAT=( python2_7 )

inherit distutils-r1 fdo-mime eutils

MY_PN="dispcalGUI"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="Display Calibration and Characterization powered by Argyll CMS"
HOMEPAGE="http://dispcalgui.hoech.net/"
SRC_URI="mirror://sourceforge/${PN}/${MY_P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=">=media-gfx/argyllcms-1.1.0
	dev-python/wxpython:2.8
	>=x11-libs/libX11-1.3.3
	>=x11-apps/xrandr-1.3.2
	>=x11-libs/libXxf86vm-1.1.0
	>=x11-proto/xineramaproto-1.2
	>=x11-libs/libXinerama-1.1"
RDEPEND="${DEPEND}
	>=dev-python/numpy-1.2.1"

# Just in case someone renames the ebuild
S=${WORKDIR}/${MY_P}

DOCS=(
	README.html
)

src_prepare() {
#	Prohibit setup from running xdg-* programs, resulting to sandbox violation
	cd "${S}/dispcalGUI" || die "Cannot cd to source directory."
	sed -e 's/if which(\"xdg-icon-resource\"):/if which(\"xdg-icon-resource-non-existant\"):/' \
	-e 's/if which(\"xdg-desktop-menu\"):/if which(\"xdg-desktop-menu-non-existant\"):/' \
	-i postinstall.py || die "sed'ing out the xdg-* setup functions failed"

#	Remove deprecated Encoding key from .desktop file
	cd "${S}" || die "Cannot cd to work directory."
	for offendingFile in $(grep -r -l "Encoding=UTF-8" .); do
		sed -e '/Encoding=UTF-8/d' -i "${offendingFile}" || \
		die "removing deprecated Encoding key from .desktop files failed"
	done

	distutils-r1_src_prepare
}

src_install() {
	distutils-r1_src_install
	#remove udev files
	rm -rf "${D}"/etc/udev/rules.d
}

pkg_postinst() {
#	Run xdg-* programs the Gentoo way since we removed this functionality from the original package
	fdo-mime_mime_database_update
	fdo-mime_desktop_database_update
}

pkg_postrm() {
#	Run xdg-* programs the Gentoo way since we removed this functionality from the original package
	fdo-mime_mime_database_update
	fdo-mime_desktop_database_update
}
