# Copyright 2020-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit meson

DESCRIPTION="liberally licensed VNC server library with a clean interface"
HOMEPAGE="https://github.com/any1/neatvnc/"

if [[ ${PV} == 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/any1/neatvnc.git"
else
	SRC_URI="https://github.com/any1/neatvnc/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~riscv ~x86"
fi

LICENSE="ISC"
SLOT="0"
IUSE="examples ssl jpeg tracing"

DEPEND="
	x11-libs/pixman
	x11-libs/libdrm
	dev-libs/aml
	sys-libs/zlib
	ssl? ( net-libs/gnutls:= )
	jpeg? ( media-libs/libjpeg-turbo:= )
	tracing? ( dev-util/systemtap )
"
RDEPEND="${DEPEND}"
BDEPEND="
	virtual/pkgconfig
"

src_configure() {
	local emesonargs=(
		$(meson_use examples)
		$(meson_feature jpeg)
		$(meson_feature ssl tls)
		$(meson_use tracing systemtap)
	)
	meson_src_configure
}
