# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools desktop flag-o-matic optfeature xdg

MY_P="${PN}libre-${PV#*_p}"
DESCRIPTION="DjVu viewers, encoders and utilities"
HOMEPAGE="http://djvu.sourceforge.net/"
SRC_URI="http://downloads.sourceforge.net/djvu/${MY_P}.tar.gz"
S="${WORKDIR}/${MY_P%%.3}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~mips ~ppc ppc64 ~s390 sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-solaris"
IUSE="debug doc jpeg tiff xml"

RDEPEND="jpeg? ( virtual/jpeg:0 )
	tiff? ( media-libs/tiff:0= )"
DEPEND="${RDEPEND}
	|| ( gnome-base/librsvg media-gfx/inkscape )"
BDEPEND="app-arch/unzip"

DOCS=( NEWS README )

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	use debug && append-cppflags "-DRUNTIME_DEBUG_ONLY"

	# We install all desktop files by hand.
	econf \
		$(use_enable xml xmltools) \
		$(use_with jpeg) \
		$(use_with tiff) \
		--disable-desktopfiles
}

src_install() {
	default

	find "${ED}" -name '*.la' -delete || die

	use doc && dodoc -r doc

	# Install desktop files.
	cd desktopfiles || die
	for i in {22,32,48,64}; do
		insinto /usr/share/icons/hicolor/${i}x${i}/mimetypes
		newins prebuilt-hi${i}-djvu.png image-vnd.djvu.png
	done

	insinto /usr/share/mime/packages
	doins djvulibre-mime.xml
}

pkg_postinst() {
	xdg_pkg_postinst

	elog "For additional features, you may wish to install"
	optfeature "for djviewer or browser plugin" app-text/djview
}
