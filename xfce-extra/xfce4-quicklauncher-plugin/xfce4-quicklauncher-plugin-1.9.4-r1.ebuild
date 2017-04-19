# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5
#EAUTORECONF=yes
inherit autotools xfconf

DESCRIPTION="A quicklauncher plug-in for the Xfce panel"
HOMEPAGE="https://goodies.xfce.org/projects/panel-plugins/xfce4-quicklauncher-plugin"
SRC_URI="mirror://xfce/src/panel-plugins/${PN}/${PV%.*}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ppc ppc64 sparc x86 ~x86-fbsd ~amd64-linux ~x86-linux"
IUSE="debug"

RDEPEND=">=xfce-base/xfce4-panel-4.8
	>=xfce-base/libxfcegui4-4.8"
DEPEND="${RDEPEND}
	dev-util/intltool
	>=dev-util/xfce4-dev-tools-4.8
	virtual/pkgconfig"

pkg_setup() {
	PATCHES=( "${FILESDIR}"/${P}-X-XFCE-Module-Path.patch )

	XFCONF=(
		$(use_enable debug)
		)

	DOCS=( AUTHORS ChangeLog TODO )
}

src_prepare() {
	sed -i \
		-e '/^AC_INIT/s:quicklauncher_version():quicklauncher_version:' \
		-e 's:AM_CONFIG_HEADER:AC_CONFIG_HEADERS:' \
		configure.ac || die #472522

	# Prevent glib-gettextize from running wrt #423115
	export AT_M4DIR=${EPREFIX}/usr/share/xfce4/dev-tools/m4macros
	intltoolize --automake --copy --force
	_elibtoolize --copy --force --install
	eaclocal
	eautoconf
	eautoheader
	eautomake

	xfconf_src_prepare
}
