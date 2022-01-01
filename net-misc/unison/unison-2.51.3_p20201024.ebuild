# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit desktop xdg-utils

MY_COMMIT="73f1bfa2476f907e2d781948ce9e764230bf8b27"
DESCRIPTION="Two-way cross-platform file synchronizer"
HOMEPAGE="https://www.seas.upenn.edu/~bcpierce/unison/"
SRC_URI="https://github.com/bcpierce00/unison/archive/${MY_COMMIT}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="$(ver_cut 1-2)"
KEYWORDS="~amd64 ~arm ~ppc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos ~sparc-solaris"
IUSE="debug doc gtk +ocamlopt threads"
RESTRICT="!ocamlopt? ( strip )" # https://bugs.gentoo.org/685776#c0

# ocaml version so we are sure it has ocamlopt use flag
BDEPEND="dev-lang/ocaml:=[ocamlopt?]
	doc? ( app-text/dvipsk
		app-text/ghostscript-gpl
		dev-texlive/texlive-latex )"
DEPEND="gtk? ( dev-ml/lablgtk:2= )"
RDEPEND="gtk? ( dev-ml/lablgtk:2=
	|| ( net-misc/x11-ssh-askpass net-misc/ssh-askpass-fullscreen ) )
	>=app-eselect/eselect-unison-0.4"

S="${WORKDIR}/${PN}-${MY_COMMIT}"

DOCS=( BUGS.txt CONTRIB INSTALL NEWS README ROADMAP.txt TODO.txt )

src_prepare() {
	# https://github.com/bcpierce00/unison/issues/416
	sed -e "/ifdef\ HEVEA/,/endif/d" -i doc/Makefile || die
	# https://github.com/bcpierce00/unison/pull/415
	sed -e "/myName/d" -i doc/docs.ml || die
	default
}

src_compile() {
	# build unison-manual.pdf but not .html
	if use doc; then
		local myconf="all docs HEVEA=false"
	else
		local myconf="all"
	fi

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
	emake $myconf CFLAGS=""
}

src_test() {
	emake test CFLAGS=""
}

src_install() {
	# install manually, since it's just too much
	# work to force the Makefile to do the right thing.
	local binname
	cd src || die
	for binname in unison unison-fsmonitor; do
		newbin ${binname} ${binname}-${SLOT}
	done

	if use gtk; then
		newicon -s scalable ../icons/U.svg ${PN}-${SLOT}.svg
		make_desktop_entry ${PN}-${SLOT} "${PN} (${SLOT})" "${PN}-${SLOT}"
	fi

	# Waiting for https://github.com/bcpierce00/unison/issues/411
	if use doc; then
		DOCS+=( ../doc/unison-manual.pdf )
	#	HTML_DOCS=( "${DISTDIR}/${P}-manual.html" )
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
