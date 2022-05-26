# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools xdg

DESCRIPTION="A set of open source instruments and effects for digital audio workstations"
HOMEPAGE="http://calf-studio-gear.org/"

if [[ "${PV}" = "9999" ]] ; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/calf-studio-gear/calf.git"
else
	SRC_URI="https://github.com/calf-studio-gear/calf/archive/${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="amd64 ~arm ~arm64 ~ppc ~ppc64 x86"
fi

LICENSE="LGPL-2.1"
SLOT="0"
IUSE="cpu_flags_x86_sse experimental gtk jack lash lv2 static-libs"

REQUIRED_USE="jack? ( gtk )"

BDEPEND="
	virtual/pkgconfig
"
DEPEND="
	dev-libs/atk
	dev-libs/expat
	dev-libs/glib:2
	media-sound/fluidsynth:=
	gtk? (
		x11-libs/cairo
		x11-libs/gdk-pixbuf
		x11-libs/gtk+:2
		x11-libs/pango
	)
	jack? ( virtual/jack )
	lash? ( media-sound/lash )
	lv2? ( media-libs/lv2 )
"
RDEPEND="${DEPEND}"

PATCHES=(
	"${FILESDIR}/${PN}-0.90.1-no-automagic.patch"
	"${FILESDIR}/${PN}-0.90.1-htmldir.patch"
	"${FILESDIR}/${PN}-0.90.1-desktop.patch"
)

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	local myeconfargs=(
		--prefix="${EPREFIX}"/usr
		--without-obsolete-check
		$(use_enable experimental)
		$(use_enable gtk gui)
		$(use_enable jack)
		$(use_with lash)
		$(use_with lv2 lv2)
		$(usex lv2 "--with-lv2-dir=${EPREFIX}/usr/$(get_libdir)/lv2" "")
		$(use_enable static-libs static)
		$(use_enable cpu_flags_x86_sse sse)
	)
	econf "${myeconfargs[@]}"
}

src_install() {
	default
	mv "${ED}"/usr/share/bash-completion/completions/calf \
		"${ED}"/usr/share/bash-completion/completions/calfjackhost
}
