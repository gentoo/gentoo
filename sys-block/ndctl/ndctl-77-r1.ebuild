# Copyright 2021-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit udev meson bash-completion-r1

DESCRIPTION="Helper tools and libraries for managing non-volatile memory on Linux"
HOMEPAGE="https://github.com/pmem/ndctl"
SRC_URI="https://github.com/pmem/ndctl/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2 LGPL-2.1 MIT CC0-1.0"
SLOT="0/6"
KEYWORDS="~amd64 ~x86"
IUSE="doc libtracefs systemd test"

DEPEND="
	dev-libs/iniparser:4=
	dev-libs/json-c:=
	sys-apps/keyutils:=
	sys-apps/kmod:=
	sys-apps/util-linux:=
	virtual/libudev:=
	libtracefs? ( dev-libs/libtracefs:= )
	systemd? ( sys-apps/systemd:= )
"
RDEPEND="${DEPEND}"
BDEPEND="
	doc? (
		app-text/asciidoc
		app-text/xmlto
	)
	dev-build/libtool
	virtual/pkgconfig
"

RESTRICT="!test? ( test )"

# tests require root access
RESTRICT+=" test"

DOCS=(
	README.md
	CONTRIBUTING.md
)

PATCHES=(
	"${FILESDIR}"/${PN}-77-iniparser4.patch
)

src_configure() {
	local -a emesonargs=(
		$(meson_feature systemd)
		$(meson_feature libtracefs)
		$(meson_feature doc docs)
		-Dasciidoctor=disabled
		-Dbashcompletiondir="$(get_bashcompdir)"
		-Drootprefix=/usr
		-Drootlibdir="/usr/$(get_libdir)"
	)
	meson_src_configure
}

src_install() {
	meson_src_install

	# upstream doesn't install udev rules unless using systemd
	use systemd || udev_dorules daxctl/90-daxctl-device.rules

	bashcomp_alias ndctl daxctl
	bashcomp_alias ndctl cxl
}

pkg_postinst() {
	udev_reload
}

pkg_postrm() {
	udev_reload
}
