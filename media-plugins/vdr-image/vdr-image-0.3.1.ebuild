# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-plugins/vdr-image/vdr-image-0.3.1.ebuild,v 1.8 2013/06/17 19:29:23 scarabeus Exp $

EAPI="5"

inherit vdr-plugin-2 flag-o-matic

VERSION="679" #every bump, new version

DESCRIPTION="VDR plugin: display of digital images, like jpeg, tiff, png, bmp"
HOMEPAGE="http://projects.vdr-developer.org/projects/plg-image"
SRC_URI="mirror://vdr-developerorg/${VERSION}/${P}.tar.gz"

KEYWORDS="amd64 x86"
SLOT="0"
LICENSE="GPL-2"
IUSE="exif"

COMMON_DEPEND=">=media-video/vdr-1.5.8
	>=virtual/ffmpeg-0.10
	>=media-libs/netpbm-10.0
	exif? ( media-libs/libexif )"

DEPEND="${COMMON_DEPEND}
	virtual/pkgconfig"

RDEPEND="${COMMON_DEPEND}
	>=media-tv/gentoo-vdr-scripts-0.2.2"

VDR_RCADDON_FILE="${FILESDIR}/rc-addon-0.3.0.sh"
BUILD_PARAMS="-j1"

src_prepare() {
	# remove empty translation file
	rm "${S}"/po/{cs_CZ,da_DK,et_EE,hr_HR,hu_HU,nn_NO,pl_PL,ro_RO}.po

	vdr-plugin-2_src_prepare

	epatch "${FILESDIR}/${P}-gentoo.diff" \
		"${FILESDIR}/${P}-ffmpeg-1.patch"

	use !exif && sed -i "s:#WITHOUT_LIBEXIF:WITHOUT_LIBEXIF:" Makefile

	if has_version "<=virtual/ffmpeg-0.4.9_p20061016"; then
		BUILD_PARAMS="${BUILD_PARAMS} WITHOUT_SWSCALER=1"
	fi

	# UINT64_C is needed by ffmpeg headers
	append-cppflags -D__STDC_CONSTANT_MACROS
}

src_install() {
	vdr-plugin-2_src_install

	insinto /etc/vdr/imagecmds
	newins examples/imagecmds.conf imagecmds.example.conf
	newins examples/imagecmds.conf.DE imagecmds.example.conf.de

	insinto /etc/vdr/plugins/image
	doins examples/imagesources.conf

	into /usr/share/vdr/image
	dobin scripts/imageplugin.sh
	newbin scripts/mount.sh mount-image.sh
}
