# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools

DESCRIPTION="Portland utils for cross-platform/cross-toolkit/cross-desktop interoperability"
HOMEPAGE="https://www.freedesktop.org/wiki/Software/xdg-utils/"
if [[ ${PV} == *_p* ]] ; then
	MY_COMMIT="d4f00e1d803038af4f245949d8c747a384117852"
	SRC_URI="https://gitlab.freedesktop.org/xdg/xdg-utils/-/archive/${MY_COMMIT}/${P}.tar.bz2"
	S="${WORKDIR}"/xdg-utils-${MY_COMMIT}
else
	SRC_URI="https://gitlab.freedesktop.org/xdg/xdg-utils/-/archive/v${PV}/${PN}-v${PV}.tar.bz2"
	S="${WORKDIR}"/${PN}-v${PV}
fi

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~loong ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~amd64-linux ~x86-linux"
IUSE="dbus doc gnome plasma X"
REQUIRED_USE="gnome? ( dbus )"

RDEPEND="
	dev-perl/File-MimeInfo
	dev-util/desktop-file-utils
	x11-misc/shared-mime-info
	dbus? (
		sys-apps/dbus
		gnome? (
			dev-perl/Net-DBus
			dev-perl/X11-Protocol
		)
	)
	plasma? (
		virtual/pkgconfig
		|| (
			(
				kde-frameworks/kservice:6
				dev-qt/qtbase:6
			)
			(
				kde-frameworks/kservice:5
				dev-qt/qtpaths:5
			)
		)
	)
	X? (
		x11-apps/xprop
		x11-apps/xset
	)
"
BDEPEND="
	app-alternatives/awk
	>=app-text/xmlto-0.0.28-r3[text(+)]
"

# Tests run random system programs, including interactive programs
# that block forever
RESTRICT="test"

PATCHES=(
	"${FILESDIR}"/${P}-xdg-mime-default.patch
	"${FILESDIR}"/${PN}-1.2.1-qtpaths.patch
)

src_prepare() {
	default

	if [[ ${PV} == *_p* ]] ; then
		# If you choose to do git snapshot instead of patchset, you need to remember
		# to run `autoconf` in ./ and `make scripts-clean` in ./scripts/ to refresh
		# all the files
		eautoreconf
	fi
}

src_configure() {
	export ac_cv_path_XMLTO="$(type -P xmlto) --skip-validation" #502166
	default
	emake -C scripts scripts-clean
}

src_install() {
	default

	dodoc RELEASE_NOTES

	newdoc scripts/xsl/README README.xsl
	use doc && dodoc -r scripts/html

	# Install default XDG_DATA_DIRS, bug #264647
	echo XDG_DATA_DIRS=\"${EPREFIX}/usr/local/share\" > 30xdg-data-local || die
	echo 'COLON_SEPARATED="XDG_DATA_DIRS XDG_CONFIG_DIRS"' >> 30xdg-data-local || die
	doenvd 30xdg-data-local

	echo XDG_DATA_DIRS=\"${EPREFIX}/usr/share\" > 90xdg-data-base || die
	echo XDG_CONFIG_DIRS=\"${EPREFIX}/etc/xdg\" >> 90xdg-data-base || die
	doenvd 90xdg-data-base
}

pkg_postinst() {
	[[ -x $(type -P gtk-update-icon-cache) ]] \
		|| elog "Install dev-util/gtk-update-icon-cache for the gtk-update-icon-cache command."
}
