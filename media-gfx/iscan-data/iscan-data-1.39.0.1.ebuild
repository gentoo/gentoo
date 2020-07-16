# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit udev

DESCRIPTION="Image Scan! for Linux data files"
HOMEPAGE="http://download.ebz.epson.net/dsc/search/01/search/?OSC=LX"
SRC_URI="http://support.epson.net/linux/src/scanner/iscan/${PN}_$(ver_rs 3 -).tar.gz"
LICENSE="GPL-2"
SLOT="0"

KEYWORDS="amd64 x86"
IUSE="udev"

DEPEND="
	udev? (
		dev-libs/libxslt
		media-gfx/sane-backends
	)"
RDEPEND=""

S="${WORKDIR}/${PN}-$(ver_cut 1-3)"

DOCS=( NEWS SUPPORTED-DEVICES KNOWN-PROBLEMS )

src_install() {
	ewarn "Some profiles automatically enable udev which will cause install"
	ewarn "to fail if media-gfx/sane-backends is not already installed."
	default

	if use udev; then
	# create udev rules
		local rulesdir=$(get_udevdir)/rules.d
		dodir ${rulesdir}
		"${D}/usr/$(get_libdir)/iscan-data/make-policy-file" \
			--force --mode udev \
			-d "${D}/usr/share/iscan-data/epkowa.desc" \
			-o "${D}${rulesdir}/99-iscan.rules" || die
	fi
}
