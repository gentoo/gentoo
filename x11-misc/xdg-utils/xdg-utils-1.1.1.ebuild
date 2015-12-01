# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit autotools eutils

MY_P=${P/_/-}

DESCRIPTION="Portland utils for cross-platform/cross-toolkit/cross-desktop interoperability"
HOMEPAGE="http://portland.freedesktop.org/"
#SRC_URI="https://dev.gentoo.org/~johu/distfiles/${P}.tar.xz"
#SRC_URI="http://people.freedesktop.org/~rdieter/${PN}/${MY_P}.tar.gz
#	https://dev.gentoo.org/~ssuominen/${P}-patchset-1.tar.xz"
SRC_URI="http://portland.freedesktop.org/download/${MY_P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha amd64 arm ~arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~amd64-fbsd ~x86-fbsd ~x86-freebsd ~x86-interix ~amd64-linux ~x86-linux ~x86-macos ~sparc-solaris ~x64-solaris ~x86-solaris"
IUSE="doc +perl"

RDEPEND="dev-util/desktop-file-utils
	x11-misc/shared-mime-info
	x11-apps/xprop
	x11-apps/xset
	perl? ( dev-perl/File-MimeInfo )"
DEPEND=">=app-text/xmlto-0.0.26-r1[text(+)]"

DOCS="README RELEASE_NOTES TODO" # ChangeLog is bogus, see git instead

RESTRICT="test" # Disabled because of sandbox violation(s)

#S=${WORKDIR}/${MY_P}

src_prepare() {
	# If you choose to do git snapshot instead of patchset, you need to remember
	# to run `autoconf` in ./ and `make scripts-clean` in ./scripts/ to refresh
	# all the files
	if [[ -d ${WORKDIR}/patch ]]; then
		EPATCH_SUFFIX=patch EPATCH_FORCE=yes epatch
	fi
	eautoreconf
	pushd scripts && make scripts-clean && popd
}

src_configure() {
	export ac_cv_path_XMLTO="$(type -P xmlto) --skip-validation" #502166
	default
}

src_install() {
	default

	newdoc scripts/xsl/README README.xsl
	use doc && dohtml -r scripts/html

	# Install default XDG_DATA_DIRS, bug #264647
	echo XDG_DATA_DIRS=\"${EPREFIX}/usr/local/share\" > 30xdg-data-local
	echo 'COLON_SEPARATED="XDG_DATA_DIRS XDG_CONFIG_DIRS"' >> 30xdg-data-local
	doenvd 30xdg-data-local

	echo XDG_DATA_DIRS=\"${EPREFIX}/usr/share\" > 90xdg-data-base
	echo XDG_CONFIG_DIRS=\"${EPREFIX}/etc/xdg\" >> 90xdg-data-base
	doenvd 90xdg-data-base
}

pkg_postinst() {
	[[ -x $(type -P gtk-update-icon-cache) ]] || elog "Install x11-libs/gtk+:2 for the gtk-update-icon-cache command."
}
