# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
inherit autotools xdg

DESCRIPTION="A collection of data files to add support for chemical MIME types"
HOMEPAGE="https://github.com/dleidert/chemical-mime"
COMMIT="4fd66e3b3b7d922555d1e25587908b036805c45b"
SRC_URI="https://github.com/dleidert/chemical-mime/archive/${COMMIT}.tar.gz -> ${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="amd64 arm arm64 x86"
IUSE=""

RDEPEND="x11-misc/shared-mime-info"
DEPEND="${RDEPEND}"
BDEPEND="
	dev-util/intltool
	dev-util/desktop-file-utils
	dev-libs/libxslt
	virtual/pkgconfig
"

PATCHES=(
	# https://github.com/dleidert/chemical-mime/issues/5
	"${FILESDIR}"/${PN}-0.1.95-turbomole.patch
)

S="${WORKDIR}/${PN/-data/}-${COMMIT}"

src_prepare() {
	default
	# https://github.com/dleidert/chemical-mime/issues/4
	sed -i -e \
		'/<_comment/a\\t\t<generic-icon name="image-x-generic"/>' \
		src/chemical-mime-database.xml.in || die
	sed -i -e \
		's:acronym|alias|comment|:acronym|alias|comment|generic-icon|:' \
		xsl/cmd_freedesktop_org.xsl || die
	eautoreconf
}

src_configure() {
	econf \
		--disable-update-database \
		--without-gnome-mime \
		--without-kde-mime \
		--without-kde-magic
}
