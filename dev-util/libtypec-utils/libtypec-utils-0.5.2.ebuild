# Copyright 2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit meson

DESCRIPTION="Debug and diagnostic utils which interface with libtypec"
HOMEPAGE="https://github.com/libtypec/libtypec"
SRC_URI="https://github.com/libtypec/libtypec/archive/refs/tags/libtypec-${PV}.tar.gz"

S="${WORKDIR}/libtypec-libtypec-${PV}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

BDEPEND="
	virtual/pkgconfig
"
DEPEND="
	dev-libs/libtypec
	virtual/udev
"
RDEPEND="${DEPEND}"

src_compile() {
	# Build just the utils subproject
	meson setup --reconfigure utils utils_build --prefix="${EPREFIX}/usr" || die
}

src_install() {
	# Install just the utils subproject
	cd utils_build && DESTDIR="${D}" meson install || die
}
