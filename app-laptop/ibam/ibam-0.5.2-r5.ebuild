# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PATCH_LEVEL="2.1"
inherit flag-o-matic toolchain-funcs optfeature

DESCRIPTION="Intelligent Battery Monitor"
HOMEPAGE="https://ibam.sourceforge.net"
SRC_URI="
	mirror://sourceforge/${PN}/${P}.tar.gz
	mirror://debian/pool/main/${PN:0:1}/${PN}/${PN}_${PV}-${PATCH_LEVEL}.diff.gz
"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="gkrellm"

RDEPEND="
	gkrellm? (
		app-admin/gkrellm:2[X]
		x11-libs/gdk-pixbuf
		x11-libs/gtk+:2
	)
"
DEPEND="${RDEPEND}"
BDEPEND="gkrellm? ( virtual/pkgconfig )"

PATCHES=(
	"${FILESDIR}"/${P}-build.patch
	"${WORKDIR}"/${PN}_${PV}-${PATCH_LEVEL}.diff
	"${S}"/debian/patches/02deviation.dpatch
	"${S}"/debian/patches/03acpi-check.dpatch
	"${S}"/debian/patches/05_sysfs_lenovo.dpatch
)

src_compile() {
	tc-export CXX PKG_CONFIG

	append-cxxflags -std=c++03

	emake
	use gkrellm && emake krell
}

src_install() {
	dobin ibam
	dodoc CHANGES README REPORT

	if use gkrellm; then
		insinto /usr/$(get_libdir)/gkrellm2/plugins
		doins ibam-krell.so
	fi
}

pkg_postinst() {
	optfeature "using the --plot argument" sci-visualization/gnuplot
}
