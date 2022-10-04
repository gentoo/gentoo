# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

VALA_USE_DEPEND=vapigen

inherit meson gnome2-utils vala

if [[ ${PV} == *9999* ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://gitlab.gnome.org/GNOME/babl.git"
	SRC_URI=""
else
	SRC_URI="https://download.gimp.org/pub/${PN}/${PV:0:3}/${P}.tar.xz"
	KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~riscv -sparc ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x64-solaris ~x86-solaris"
fi

DESCRIPTION="A dynamic, any to any, pixel format conversion library"
HOMEPAGE="https://gegl.org/babl/"

LICENSE="LGPL-3"
SLOT="0"
IUSE="introspection lcms vala cpu_flags_x86_avx2 cpu_flags_x86_f16c cpu_flags_x86_mmx cpu_flags_x86_sse cpu_flags_x86_sse2 cpu_flags_x86_sse4_1"
REQUIRED_USE="vala? ( introspection )"

BDEPEND="
	virtual/pkgconfig
	vala? ( $(vala_depend) )
"
RDEPEND="
	introspection? ( >=dev-libs/gobject-introspection-1.32:= )
	lcms? ( >=media-libs/lcms-2.8:2 )
"
DEPEND="${RDEPEND}"

src_prepare() {
	default
	gnome2_environment_reset
}

src_configure() {
	use vala && vala_setup

	# Automagic rsvg support is just for website generation we do not call,
	#     so we don't need to fix it
	# w3m is used for dist target thus no issue for us that it is automagically
	#     detected
	local emesonargs=(
		-Dwith-docs=false
		$(meson_use introspection enable-gir)
		$(meson_use lcms with-lcms)
		$(meson_use vala enable-vapi)
		$(meson_use cpu_flags_x86_avx2 enable-avx2)
		$(meson_use cpu_flags_x86_f16c enable-f16c)
		$(meson_use cpu_flags_x86_mmx enable-mmx)
		$(meson_use cpu_flags_x86_sse enable-sse)
		$(meson_use cpu_flags_x86_sse2 enable-sse2)
		$(meson_use cpu_flags_x86_sse4_1 enable-sse4_1)
	)
	meson_src_configure
}

src_install() {
	meson_src_install

	# Bug 871690
	dosym "${ESYSROOT}"/usr/"$(get_libdir)"/pkgconfig/babl.pc /usr/"$(get_libdir)"/pkgconfig/babl-0.1.pc
}
