# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="5"

inherit vdr-plugin-2

VERSION="783" # changes with every version / new file :-(

DESCRIPTION="VDR text2skin PlugIn"
HOMEPAGE="https://projects.vdr-developer.org/projects/plg-text2skin"
SRC_URI="mirror://vdr-developerorg/${VERSION}/${P}.tgz"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~x86 ~amd64"
IUSE="contrib doc graphicsmagick +imagemagick imlib"

RDEPEND="
	>=media-video/vdr-1.6.0
	imagemagick? (
		graphicsmagick? ( media-gfx/graphicsmagick:=[cxx] )
		!graphicsmagick? ( media-gfx/imagemagick:=[cxx] )
	)
	!imagemagick? (
		imlib? (
			media-libs/imlib2
			>=media-video/vdr-1.6.0[-graphtft]
		)
	)"
DEPEND="${RDEPEND}
	sys-devel/gettext
	virtual/pkgconfig"

KEEP_I18NOBJECT="yes"

src_prepare() {
	local imagelib=

	epatch "${FILESDIR}/${P}-Makefile.patch"

	sed -i common.c -e 's#cPlugin::ConfigDirectory(PLUGIN_NAME_I18N)#"/usr/share/vdr/"PLUGIN_NAME_I18N#'

	if ! has_version ">=media-video/vdr-1.7.13"; then
		sed -i "s:-include \$(VDRDIR)/Make.global:#-include \$(VDRDIR)/Make.global:" Makefile
	fi

	if use imagemagick; then
		if use graphicsmagick; then
			imagelib="graphicsmagick"
		else
			imagelib="imagemagick"
		fi
	else
		if use imlib; then
			imagelib="imlib2"
		else
			imagelib="none"
		fi
	fi

	sed -i -e "s:\(IMAGELIB[[:space:]]*=\) .*:\1 ${imagelib}:" Makefile || die

	vdr-plugin-2_src_prepare

	if has_version ">=media-video/vdr-1.7.27"; then
		epatch "${FILESDIR}/vdr-1.7.27.diff"
	fi

	epatch "${FILESDIR}/${P}_vdr-2.1.2.diff"
}

src_install() {
	vdr-plugin-2_src_install

	keepdir "/usr/share/vdr/${VDRPLUGIN}"

	dodoc CONTRIBUTORS

	if use doc; then
		dodoc Docs/{Reference,Tutorial}.txt
	fi

	if use contrib; then
		dodoc -r contrib/
	fi
}
