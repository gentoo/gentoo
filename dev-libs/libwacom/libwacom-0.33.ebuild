# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools udev

DESCRIPTION="Library for identifying Wacom tablets and their model-specific features"
HOMEPAGE="https://github.com/linuxwacom/libwacom"
SRC_URI="https://github.com/linuxwacom/${PN}/releases/download/${P}/${P}.tar.bz2"

LICENSE="MIT"
SLOT="0"
KEYWORDS="alpha amd64 arm ia64 ppc ppc64 sparc x86"
IUSE="doc static-libs"

BDEPEND="
	virtual/pkgconfig
	doc? ( app-doc/doxygen )
"
RDEPEND="
	dev-libs/glib:2
	dev-libs/libgudev:=
"
DEPEND="${RDEPEND}"

src_prepare() {
	default
	if ! use doc; then
		sed -e 's:^\(SUBDIRS = .* \)doc:\1:' -i Makefile.am || die
	fi
	eautoreconf
}

src_configure() {
	econf $(use_enable static-libs static)
}

src_install() {
	use doc && HTML_DOCS=( doc/html/. )
	default
	local udevdir="$(get_udevdir)"
	dodir "${udevdir}/rules.d"
	# generate-udev-rules must be run from inside tools directory
	pushd tools > /dev/null || die
	./generate-udev-rules > "${ED}/${udevdir}/rules.d/65-libwacom.rules" || \
		die "generating udev rules failed"
	popd > /dev/null || die
	find "${D}" -name '*.la' -type f -delete || die
}
