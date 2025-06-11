# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# Doc generation requires pulls in asciidoc/ruby, we'll prebuild docs
# for release ebuilds.
# Scripting for this is in sam-gentoo-scripts.
: ${FVWM3_DOCS_PREBUILT:=1}

PYTHON_COMPAT=( python3_{11..13} )
GO_OPTIONAL=1
inherit go-module meson optfeature python-single-r1

DESCRIPTION="A multiple large virtual desktop window manager derived from fvwm"
HOMEPAGE="https://www.fvwm.org/"

if [[ ${PV} == 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/fvwmorg/fvwm3.git"
	EGIT_BRANCH="main"
	FVWM3_DOCS_PREBUILT=0
else
	SRC_URI="https://github.com/fvwmorg/fvwm3/releases/download/${PV}/${P}.tar.gz"
	if [[ ${FVWM3_DOCS_PREBUILT} == 1 ]]; then
		SRC_URI+=" https://deps.gentoo.zip/x11-wm/fvwm3/${P}-docs.tar.xz"
	fi
	KEYWORDS="~amd64 ~arm ~arm64 ~ppc ~ppc64 ~riscv ~x86"
fi

LICENSE="GPL-2+ FVWM
	go? ( Apache-2.0 BSD MIT )"
SLOT="0"
IUSE="bidi +go nls readline svg"
# Strictly speaking readline is not required for go,
# but as most systems already have it installed we don't users to stub their toe on REQUIRED_USE
REQUIRED_USE="${PYTHON_REQUIRED_USE} !go? ( readline )"

DOCS=( NEWS )

if [[ ${PV} == 9999 ]]; then
	DOCS+=(
		dev-docs/COMMANDS
		dev-docs/DEVELOPERS.md
		dev-docs/INSTALL.md
		dev-docs/PARSING.md
		dev-docs/TODO.md
		dev-docs/NEW-COMMANDS.md
	)
fi

BDEPEND="
	virtual/pkgconfig
	app-arch/unzip
	go? ( >=dev-lang/go-1.20 )
"

if [[ ${FVWM3_DOCS_PREBUILT} -ne 1 ]]; then
	BDEPEND+="
		dev-libs/libxslt
		dev-ruby/asciidoctor
	"
fi

COMMON_DEPEND="
	dev-lang/perl
	dev-libs/glib:2
	dev-libs/libevent:=
	media-libs/fontconfig
	media-libs/libpng:=
	x11-base/xorg-proto
	x11-libs/libICE
	x11-libs/libSM
	x11-libs/libX11
	x11-libs/libxcb
	x11-libs/libXcursor
	x11-libs/libXext
	x11-libs/libXfixes
	x11-libs/libXft
	x11-libs/libxkbcommon
	x11-libs/libXpm
	x11-libs/libXrandr
	x11-libs/libXrender
	x11-libs/xtrans
	bidi? ( dev-libs/fribidi )
	readline? (
		sys-libs/readline:=
	)
	svg? (
		gnome-base/librsvg:2
		x11-libs/cairo
	)
"

RDEPEND="
	${COMMON_DEPEND}
	${PYTHON_DEPS}
	!x11-wm/fvwm
"

DEPEND="${COMMON_DEPEND}"

src_configure() {
	local emesonargs=(
		"-Dpng=enabled"
		"-Dsm=enabled"
		"-Dxcursor=enabled"
		"-Dxfixes=enabled"
		"-Dxpm=enabled"
		"-Dxrender=enabled"
		$(meson_feature bidi)
		$(meson_feature go golang)
		$(meson_feature nls iconv)
		$(meson_feature nls)
		$(meson_feature readline) # not required for go but it won't hurt to enable it
		$(meson_feature svg cairo) # Pick 1 of 'cairo', 'cairo-svg', or 'libsvg-cairo'; add the appropriate dependency
		$(meson_feature svg)
		"-Dcairo-svg=disabled"
		"-Dlibsvg-cairo=disabled"
		"-Ddocdir=${EPREFIX}/usr/share/doc/${PF}"
	)

	if [[ ${FVWM3_DOCS_PREBUILT} -ne 1 ]]; then
		emesonargs+=(
			"-Dhtmldoc=true"
			"-Dmandoc=true"
		)
	else
		# Probably not required, but let's be safe
		emesonargs+=(
			"-Dhtmldoc=false"
			"-Dmandoc=false"
		)
	fi

	meson_src_configure
}

src_install() {
	# Since we're manually handling docs installation, let's do that first
	# and then install the rest of the files "normally".
	local HTML_DOCS
	if [[ ${FVWM3_DOCS_PREBUILT} == 1 ]] ; then
		doman "${WORKDIR}"/${P}-docs/man/**/*.[0-8]
		HTML_DOCS="${WORKDIR}"/${P}-docs/html/*
	fi
	einstalldocs

	meson_src_install

	python_scriptinto "/usr/bin"
	python_doscript "${ED}/usr/bin/FvwmCommand" "${ED}/usr/bin/fvwm-menu-desktop"
}

pkg_postinst() {

	einfo "For compatibility with existing fvwm2 configurations, the ebuild will install a FvwmCommand wrapper."

	if use go; then
		einfo "FvwmPrompt has been installed, it provides the functionality of both FvwmCommand and FvwmConsole."
		einfo "If you need FvwmConsole, install ${PN} with USE=\"-go\"; however FvwmPrompt will not be installed."
	else
		einfo "FvwmConsole has been installed, hovever it is a legacy tool."
		einfo "Consider installing with USE=\"go\" which will have FvwmPrompt replace FvwmConsole to"
		einfo "provide the same functionality in a more flexible way."
	fi

	optfeature_header "Useful optional features:"
	optfeature "Screen locking" x11-misc/xlockmore
	optfeature "NetPBM support (used by FvwmScript-ScreenDump)" media-libs/netpbm
}
