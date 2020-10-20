# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit desktop xdg-utils

# Use the docs for the last 'normal' release
DOC_P="${PN}-2.48.4"
DESCRIPTION="Two-way cross-platform file synchronizer"
HOMEPAGE="https://www.seas.upenn.edu/~bcpierce/unison/"
SRC_URI="https://github.com/bcpierce00/unison/archive/v${PV/_p/v}.tar.gz -> ${P/_p/v}.tar.gz"
# No manual.pdf or manual.html available for this version
SRC_URI+=" doc? ( https://www.seas.upenn.edu/~bcpierce/unison/download/releases/${DOC_VER}/${DOC_P}-manual.pdf
		https://www.seas.upenn.edu/~bcpierce/unison/download/releases/${DOC_VER}/${DOC_P}-manual.html )
"

LICENSE="GPL-2"
SLOT="$(ver_cut 1-2)"
KEYWORDS="amd64 ~arm ~ppc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos ~sparc-solaris"
IUSE="debug doc gtk +ocamlopt threads"

# Upstream, for this version, has explicitly disabled test with marker
# "Skipping some tests -- remove me!". Given the potentially destructive nature
# of those tests, let's not try to run them (they're re-enabled in subsequent
# releases).
RESTRICT="test !ocamlopt? ( strip )"

# ocaml version so we are sure it has ocamlopt use flag
DEPEND="<dev-lang/ocaml-4.10.0:=[ocamlopt?]
	gtk? ( dev-ml/lablgtk:2= )"

RDEPEND="gtk? ( dev-ml/lablgtk:2=
	|| ( net-misc/x11-ssh-askpass net-misc/ssh-askpass-fullscreen ) )
	>=app-eselect/eselect-unison-0.4"

S="${WORKDIR}"/${P/_p/v}/src

PATCHES=(
	"${FILESDIR}"/${PN}-2.48.4-Makefile-dep.patch
	"${FILESDIR}"/${PN}-2.48.15_p4-ocaml-4.08.patch # https://bugs.gentoo.org/709646
)

DOCS=( BUGS.txt CONTRIB INSTALL NEWS README ROADMAP.txt TODO.txt )

src_compile() {
	local myconf="all"

	if use threads; then
		myconf="$myconf THREADS=true"
	fi

	if use debug; then
		myconf="$myconf DEBUGGING=true"
	fi

	if use gtk; then
		myconf="$myconf UISTYLE=gtk2"
	else
		myconf="$myconf UISTYLE=text"
	fi

	use ocamlopt || myconf="$myconf NATIVE=false"

	# Discard cflags as it will try to pass them to ocamlc...
	emake $myconf CFLAGS="" buildexecutable
}

src_test() {
	emake selftest CFLAGS=""
}

src_install() {
	# install manually, since it's just too much
	# work to force the Makefile to do the right thing.
	local binname
	for binname in unison unison-fsmonitor; do
		newbin ${binname} ${binname}-${SLOT}
	done

	if use gtk; then
		newicon -s scalable ../icons/U.svg ${PN}-${SLOT}.svg
		make_desktop_entry unison-${SLOT} "${PN} (${SLOT})" "${EPREFIX}/usr/share/icons/hicolor/scalable/apps/${PN}-${SLOT}.svg"
	fi

	if use doc; then
		DOCS+=( "${DISTDIR}/${DOC_P}-manual.pdf" )
		HTML_DOCS=( "${DISTDIR}/${DOC_P}-manual.html" )
	fi

	einstalldocs
}

pkg_postinst() {
	elog "Unison now uses SLOTs, so you can specify servercmd=/usr/bin/unison-${SLOT}"
	elog "in your profile files to access exactly this version over ssh."
	elog "Or you can use 'eselect unison' to set the version."
	eselect unison update || die

	if use gtk; then
		xdg_icon_cache_update
	fi
}

pkg_postrm() {
	if use gtk; then
		xdg_icon_cache_update
	fi
}
