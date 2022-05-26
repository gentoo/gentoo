# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="A GTK+ application for controlling V4L preferences of a web cam device"
HOMEPAGE="https://github.com/jwrdegoede/gtk-v4l/"
# No 0.4 release tag on GitHub so until 0.5 has been released, stick
# with the previously mirrored tarball from FedoraHosted.
SRC_URI="mirror://gentoo/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND=">=dev-libs/glib-2
	dev-libs/libgudev:=
	>=media-libs/libv4l-0.6
	x11-libs/gtk+:3"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

PATCHES=(
	"${FILESDIR}"/${PN}-0.4-device-remove-source-on-finalize.patch
)

src_prepare() {
	default
	sed -i -e '/^Categories/s:Application:GTK:' ${PN}.desktop.in || die
}

src_install() {
	default
	find "${ED}" -name '*.la' -delete || die
}
