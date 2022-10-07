# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit multilib-minimal

DESCRIPTION="Free lossless audio encoder and decoder"
HOMEPAGE="https://xiph.org/flac/"
SRC_URI="https://downloads.xiph.org/releases/${PN/-compat}/${P/-compat}.tar.xz"
S="${WORKDIR}/${P/-compat}"

LICENSE="BSD FDL-1.2 GPL-2 LGPL-2.1"
SLOT="8.3.0"
KEYWORDS="~amd64 ~x86"
IUSE="+cxx ogg cpu_flags_x86_sse"

RDEPEND="
	!media-libs/flac:0/0
	ogg? ( media-libs/libogg[${MULTILIB_USEDEP}] )"
DEPEND="${RDEPEND}"
BDEPEND="
	app-arch/xz-utils
	sys-devel/gettext
	virtual/pkgconfig
	abi_x86_32? ( dev-lang/nasm )"

multilib_src_configure() {
	local myeconfargs=(
		--disable-debug
		--disable-altivec
		--disable-vsx
		--disable-doxygen-docs
		--disable-examples
		--disable-xmms-plugin
		$(use_enable cpu_flags_x86_sse sse)
		$(use_enable cxx cpplibs)
		$(use_enable ogg)

		# cross-compile fix (bug #521446)
		# no effect if ogg support is disabled
		--with-ogg
	)
	ECONF_SOURCE="${S}" econf "${myeconfargs[@]}"
}

multilib_src_test() {
	if [[ ${UID} != 0 ]]; then
		emake -j1 check
	else
		ewarn "Tests will fail if ran as root, skipping."
	fi
}

multilib_src_install_all() {
	rm -r "${ED}"/usr/bin || die
	rm -r "${ED}"/usr/include || die
	rm -r "${ED}"/usr/share || die
	rm -r "${ED}"/usr/lib*/pkgconfig || die
	rm -r "${ED}"/usr/lib*/*.so || die

	find "${ED}" -type f -name '*.la' -delete || die
}
