# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit desktop eutils flag-o-matic xdg-utils

MY_P="${PN}libre-${PV#*_p}"

DESCRIPTION="DjVu viewers, encoders and utilities"
HOMEPAGE="http://djvu.sourceforge.net/"
SRC_URI="http://downloads.sourceforge.net/djvu/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 arm arm64 hppa ia64 ~mips ppc ppc64 ~s390 ~sh sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-solaris"
IUSE="debug doc jpeg tiff xml"

PATCHES=( "${FILESDIR}"/fix-CVE-2019-18804.patch )

RDEPEND="jpeg? ( virtual/jpeg:0 )
	tiff? ( media-libs/tiff:0= )"
DEPEND="${RDEPEND}
	|| ( gnome-base/librsvg media-gfx/inkscape )"

S=${WORKDIR}/${MY_P%%.3}

src_configure() {
	use debug && append-cppflags "-DRUNTIME_DEBUG_ONLY"

	# We install all desktop files by hand.
	econf \
		$(use_enable xml xmltools) \
		$(use_with jpeg) \
		$(use_with tiff) \
		--disable-desktopfiles
}

DOCS=( NEWS README )

src_install() {
	default

	find "${ED}" -name '*.la' -delete || die

	use doc && dodoc -r doc

	# Install desktop files.
	cd desktopfiles
	for i in {22,32,48,64}; do
		insinto /usr/share/icons/hicolor/${i}x${i}/mimetypes
		newins prebuilt-hi${i}-djvu.png image-vnd.djvu.png
	done
	insinto /usr/share/mime/packages
	doins djvulibre-mime.xml
}

pkg_postinst() {
	xdg_icon_cache_update
	xdg_mimeinfo_database_update
	has_version app-text/djview || \
		optfeature "For djviewer or browser plugin" app-text/djview
}

pkg_postrm() {
	xdg_icon_cache_update
	xdg_mimeinfo_database_update
}
