# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake flag-o-matic toolchain-funcs xdg

DESCRIPTION="Set of open source instruments and effects for digital audio workstations"
HOMEPAGE="https://calf-studio-gear.org/"

if [[ ${PV} == *9999* ]] ; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/calf-studio-gear/calf.git"
else
	SRC_URI="https://github.com/calf-studio-gear/calf/archive/${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="amd64 ~arm ~arm64 ~ppc ~ppc64 x86"
fi

LICENSE="LGPL-2.1"
SLOT="0"
IUSE="cpu_flags_x86_sse experimental gui jack lash lv2"

REQUIRED_USE="jack? ( gui )"

BDEPEND="
	virtual/pkgconfig
"
DEPEND="
	>=app-accessibility/at-spi2-core-2.46.0
	dev-libs/expat
	dev-libs/glib:2
	media-sound/fluidsynth:=
	gui? (
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
	"${FILESDIR}/${P}-gnuinstalldirs.patch" # in 0.90.7
	# pending upstream PRs:
	"${FILESDIR}/${P}-desktop-file.patch" # bug 955628
	"${FILESDIR}/${P}-lv2gui.patch" # bug 954142
)

src_configure() {
	# Upstream append -ffast-math by default, however since libtool links C++
	# shared libs with -nostdlib, this causes symbol resolution error for
	# __powidn2 when using compiler-rt. Disable fast math on compiler-rt until
	# a better fix is found.
	[[ $(tc-get-c-rtlib) = "compiler-rt" ]] && append-cxxflags "-fno-fast-math"

	local mycmakeargs=(
		-DWANT_GUI=$(usex gui)
		-DWANT_JACK=$(usex jack)
		-DWANT_LASH=$(usex lash)
		-DWANT_LV2=$(usex lv2)
		-DWANT_LV2_GUI=$(usex lv2)
		-DWANT_SORDI=ON
		-DWANT_EXPERIMENTAL=$(usex experimental)
	)
	cmake_src_configure
}

src_install() {
	cmake_src_install
	mv "${ED}"/usr/share/bash-completion/completions/calf \
		"${ED}"/usr/share/bash-completion/completions/calfjackhost || die "Failed to install bash completion"
}
