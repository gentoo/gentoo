# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit autotools

MY_P="${P/_/-}"

DESCRIPTION="Portland utils for cross-platform/cross-toolkit/cross-desktop interoperability"
HOMEPAGE="https://www.freedesktop.org/wiki/Software/xdg-utils/"
#SRC_URI="https://dev.gentoo.org/~johu/distfiles/${P}.tar.xz"
#SRC_URI="https://people.freedesktop.org/~rdieter/${PN}/${MY_P}.tar.gz
#	https://dev.gentoo.org/~ssuominen/${P}-patchset-1.tar.xz"
SRC_URI="https://portland.freedesktop.org/download/${MY_P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="alpha amd64 arm arm64 hppa ia64 ~mips ppc ppc64 s390 ~sh sparc x86 ~amd64-linux ~x86-linux ~x86-macos ~x64-solaris"
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
DEPEND=">=app-text/xmlto-0.0.26-r1[text(+)]"

DOCS=( ChangeLog README RELEASE_NOTES TODO )

RESTRICT="test" # Disabled because of sandbox violation(s)

PATCHES=(
	"${FILESDIR}"/xdg-utils-1.1.3-xdg-open-pcmanfm.patch
)

#S=${WORKDIR}/${MY_P}

src_prepare() {
	default
	# If you choose to do git snapshot instead of patchset, you need to remember
	# to run `autoconf` in ./ and `make scripts-clean` in ./scripts/ to refresh
	# all the files
	if [[ -d "${WORKDIR}/patch" ]]; then
		eapply "${WORKDIR}/patch"
	fi
	eautoreconf
}

src_configure() {
	export ac_cv_path_XMLTO="$(type -P xmlto) --skip-validation" #502166
	default
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
