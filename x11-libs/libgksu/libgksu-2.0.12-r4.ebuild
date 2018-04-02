# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
GNOME2_EAUTORECONF="yes"

inherit gnome2

DESCRIPTION="A library for integration of su into applications"
HOMEPAGE="http://www.nongnu.org/gksu/"
SRC_URI="https://people.debian.org/~kov/gksu/${P}.tar.gz"

LICENSE="LGPL-2"
SLOT="2"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~ia64 ~mips ~ppc ~ppc64 ~sh ~sparc ~x86 ~x86-fbsd"
IUSE="nls static-libs"

COMMON_DEPEND="
	>=x11-libs/gtk+-2.12:2
	x11-libs/libX11
	>=gnome-base/gconf-2
	gnome-base/libgnome-keyring
	x11-libs/startup-notification
	>=gnome-base/libgtop-2:2=
	nls? ( >=sys-devel/gettext-0.14.1 )
"
DEPEND="${COMMON_DEPEND}
	dev-util/gtk-doc-am
	>=dev-util/intltool-0.35.5
	virtual/pkgconfig
"
RDEPEND="${COMMON_DEPEND}
	app-admin/sudo
"

PATCHES=(
	# Fix compilation on bsd
	"${FILESDIR}"/${PN}-2.0.0-fbsd.patch

	# Fix wrong usage of LDFLAGS, bug #226837
	"${FILESDIR}"/${PN}-2.0.7-libs.patch

	# Use po/LINGUAS
	"${FILESDIR}"/${PN}-2.0.7-polinguas.patch

	# Don't forkpty; bug #298289
	"${FILESDIR}"/${P}-revert-forkpty.patch

	# Make this gmake-3.82 compliant, bug #333961
	"${FILESDIR}"/${P}-fix-make-3.82.patch

	# Do not build test programs that are never executed; also fixes bug
	# #367397 (underlinking issues).
	"${FILESDIR}"/${P}-notests.patch

	# Fix automake-1.11.2 compatibility, bug #397411
	# Fix gksu-run-helper path, bug #640772
	"${FILESDIR}"/${P}-automake-1.11.2-v2.patch
	"${FILESDIR}"/${P}-missing-libs.patch

	# Fix build with format-security, bug #517614
	"${FILESDIR}"/${P}-format_security.patch

	# Fix .desktop file validation, bug #512364
	"${FILESDIR}"/${P}-desktop-validation.patch

	# Collection of patches from Debian
	"${FILESDIR}"/${P}-g_markup_escape_text_for_command.patch
	"${FILESDIR}"/${P}-sudo_keep_env.patch
	"${FILESDIR}"/${P}-correct_colormap_get.patch
)

src_prepare() {
	sed -i -e 's:AM_CONFIG_HEADER:AC_CONFIG_HEADERS:' configure.ac || die #467026
	gnome2_src_prepare
}

src_configure() {
	gnome2_src_configure \
		$(use_enable nls) \
		$(use_enable static-libs static)
}
