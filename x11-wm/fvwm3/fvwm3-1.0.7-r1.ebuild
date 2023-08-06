# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{9..11} )
GO_OPTIONAL=1
inherit autotools desktop flag-o-matic go-module python-single-r1 toolchain-funcs

DESCRIPTION="A multiple large virtual desktop window manager derived from fvwm"
HOMEPAGE="https://www.fvwm.org/"

if [[ ${PV} == 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/fvwmorg/fvwm3.git"
	EGIT_BRANCH="main"
else
	SRC_URI="https://github.com/fvwmorg/fvwm3/releases/download/${PV}/${P}.tar.gz"
	KEYWORDS="~amd64 ~riscv"
fi

LICENSE="GPL-2+ FVWM
	go? ( Apache-2.0 BSD MIT )"
SLOT="0"
IUSE="bidi debug doc +go netpbm nls perl readline stroke svg tk lock"
REQUIRED_USE="
	${PYTHON_REQUIRED_USE}"

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
	doc? ( dev-libs/libxslt
		dev-ruby/asciidoctor )
	app-arch/unzip
	go? ( >=dev-lang/go-1.14 )
"

RDEPEND="${PYTHON_DEPS}
	${COMMON_DEPEND}
	!x11-wm/fvwm
	dev-lang/perl
	dev-libs/glib:2
	dev-libs/libevent:=
	media-libs/fontconfig
	media-libs/libpng:=
	sys-apps/debianutils
	sys-libs/zlib
	x11-libs/libICE
	x11-libs/libSM
	x11-libs/libX11
	x11-libs/libXau
	x11-libs/libxcb
	x11-libs/libXcursor
	x11-libs/libXdmcp
	x11-libs/libXext
	x11-libs/libXfixes
	x11-libs/libXft
	x11-libs/libXpm
	x11-libs/libXrandr
	x11-libs/libXrender
	bidi? ( dev-libs/fribidi )
	lock? ( x11-misc/xlockmore )
	netpbm? ( media-libs/netpbm )
	perl? ( tk? (
			dev-lang/tk
			dev-perl/Tk
			>=dev-perl/X11-Protocol-0.56
		)
	)
	readline? (
		sys-libs/ncurses:=
		sys-libs/readline:=
	)
	stroke? ( dev-libs/libstroke )
	svg? (
		gnome-base/librsvg:2
		x11-libs/cairo
	)"

DEPEND="${COMMON_DEPEND}
	x11-base/xorg-proto"

src_prepare() {
	default
	use go && ( sed -e 's/GOFLAGS=-ldflags="-s -w"/GOFLAGS=/' \
		-i bin/FvwmPrompt/Makefile.am || die )

	eautoreconf
}

src_configure() {
	# Non-upstream email where bugs should be sent; used in fvwm-bug.
	export FVWM_BUGADDR="desktop-wm@nogentoo.org"

	# Recommended by upstream for release. Doesn't really matter for live ebuilds.
	append-flags -fno-strict-aliasing

	# Signed chars are required.
	for arch in arm arm64 ppc ppc64; do
		use $arch && append-flags -fsigned-chars
	done

	local myconf=(
		--with-imagepath=/usr/include/X11/bitmaps:/usr/include/X11/pixmaps:/usr/share/icons/fvwm
		--enable-package-subdirs
		$(use_enable bidi)
		$(use_enable doc mandoc)
		$(use_enable go golang)
		$(use_enable nls)
		$(use_enable nls iconv)
		$(use_enable perl perllib)
		$(use_with readline readline-library)
		$(use_enable svg rsvg)
		--enable-png
	)

	use readline && myconf+=( --without-termcap-library )

	econf "${myconf[@]}"
}

src_compile() {
	PREFIX="${EPREFIX}/usr" emake AR="$(tc-getAR)"
	if [[ ${PV} == *9999 ]]; then
		use doc && emake -C doc
	fi
}

src_install() {
	emake DESTDIR="${ED}" prefix="/usr" exec_prefix="/usr" datarootdir="/usr/share" install

	exeinto /etc/X11/Sessions
	newexe - ${PN} <<-EOF
	#!/bin/sh
	${PN}
	EOF

	python_scriptinto "/usr/bin"
	python_doscript "${ED}/usr/bin/FvwmCommand" "${ED}/usr/bin/fvwm-menu-desktop"
	einstalldocs

	make_session_desktop fvwm3 /usr/bin/fvwm3
}

pkg_postinst() {
	if use go; then
		ewarn "FvwmPrompt has been installed, it provides the functionality of both FvwmCommand and FvwmConsole."
		ewarn "For compatibility with the existing fvwm2 configurations, the ebuild will install a FvwmCommand wrapper."
		ewarn "If you need FvwmConsole, install ${PN} with USE=\"-go\";"
		ewarn "however FvwmPrompt and FvwmCommand will not be installed."
	else
		ewarn "FvwmConsole has been installed, but FvwmCommand and FvwmPrompt are no longer included in this ebuild."
		ewarn "If you need FvwmPrompt or FvwmCommand, install ${PN} with USE=\"go\"."
		ewarn "In that case, FvwmPrompt will replace FvwmConsole and provide the same functionality in a more flexible way."
	fi
}
