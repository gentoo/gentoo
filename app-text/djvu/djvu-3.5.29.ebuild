# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit flag-o-matic optfeature xdg

MY_P="${PN}libre-${PV#*_p}"
DESCRIPTION="DjVu viewers, encoders and utilities"
HOMEPAGE="https://djvu.sourceforge.net/"
SRC_URI="https://downloads.sourceforge.net/djvu/${MY_P}.tar.gz"
S="${WORKDIR}/${MY_P%%.3}"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ~mips ppc ppc64 ~riscv ~s390 ~sparc x86 ~x64-macos"
IUSE="debug doc jpeg tiff xml"

RDEPEND="
	jpeg? ( media-libs/libjpeg-turbo:= )
	tiff? ( media-libs/tiff:= )
"
DEPEND="${RDEPEND}"
# inkscape/rsvg-convert are used to generate icons at build-time only
BDEPEND="
	app-arch/unzip
	|| ( gnome-base/librsvg media-gfx/inkscape )
"

src_configure() {
	use debug && append-cppflags -DRUNTIME_DEBUG_ONLY

	local myeconfargs=(
		$(use_enable xml xmltools)
		$(use_with jpeg)
		$(use_with tiff)

		# We install all desktop files by hand
		--disable-desktopfiles
	)

	econf "${myeconfargs[@]}"
}

src_install() {
	default

	find "${ED}" -name '*.la' -delete || die

	use doc && dodoc -r doc

	# Install desktop files.
	cd desktopfiles || die
	local i
	for i in {22,32,48,64}; do
		insinto /usr/share/icons/hicolor/${i}x${i}/mimetypes
		newins prebuilt-hi${i}-djvu.png image-vnd.djvu.png
	done

	insinto /usr/share/mime/packages
	doins djvulibre-mime.xml
}

pkg_postinst() {
	xdg_pkg_postinst

	optfeature "djviewer or browser plugin" app-text/djview
}
