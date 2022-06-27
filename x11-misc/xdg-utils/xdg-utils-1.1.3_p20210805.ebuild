# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools

MY_COMMIT="1a58bc28f6844898532daf9ee1bf6da7764955a9"
DESCRIPTION="Portland utils for cross-platform/cross-toolkit/cross-desktop interoperability"
HOMEPAGE="https://www.freedesktop.org/wiki/Software/xdg-utils/"
SRC_URI="https://gitlab.freedesktop.org/xdg/xdg-utils/-/archive/${MY_COMMIT}/${P}.tar.bz2"
# https://gitlab.freedesktop.org/xdg/xdg-utils/-/merge_requests/24
SRC_URI+=" https://dev.gentoo.org/~sam/distfiles/${CATEGORY}/${PN}/${PN}-1.1.3_p20200220-no-which.patch.xz"
S="${WORKDIR}"/xdg-utils-${MY_COMMIT}

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~loong ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~amd64-linux ~x86-linux"
IUSE="dbus doc gnome"
REQUIRED_USE="gnome? ( dbus )"

RDEPEND="
	dev-util/desktop-file-utils
	dev-perl/File-MimeInfo
	dbus? (
		sys-apps/dbus
		gnome? (
			dev-perl/Net-DBus
			dev-perl/X11-Protocol
		)
	)
	x11-misc/shared-mime-info
	x11-apps/xprop
	x11-apps/xset
"
BDEPEND="
	>=app-text/xmlto-0.0.28-r3[text(+)]
	virtual/awk
"

DOCS=( ChangeLog README RELEASE_NOTES TODO )

# Tests run random system programs, including interactive programs
# that block forever
RESTRICT="test"

PATCHES=(
	"${WORKDIR}"/${PN}-1.1.3_p20200220-no-which.patch
)

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
