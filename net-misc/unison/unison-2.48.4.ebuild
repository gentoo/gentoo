# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="5"

inherit eutils versionator

IUSE="gtk doc static debug threads +ocamlopt test"

DESCRIPTION="Two-way cross-platform file synchronizer"
HOMEPAGE="https://www.seas.upenn.edu/~bcpierce/unison/"
LICENSE="GPL-2"
SLOT="$(get_version_component_range 1-2 ${PV})"
KEYWORDS="amd64 ~arm ~ppc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos ~sparc-solaris"

# ocaml version so we are sure it has ocamlopt use flag
DEPEND="dev-lang/ocaml[ocamlopt?]
	gtk? ( dev-ml/lablgtk )
	test? ( || ( dev-util/ctags >=app-editors/emacs-23.1:* ) )"

RDEPEND="gtk? ( dev-ml/lablgtk
	|| ( net-misc/x11-ssh-askpass net-misc/ssh-askpass-fullscreen ) )
	!net-misc/unison:0
	app-eselect/eselect-unison"

#PDEPEND="gtk? ( media-fonts/font-schumacher-misc )"

RESTRICT="!ocamlopt? ( strip ) !test? ( test )"
SRC_URI="https://www.seas.upenn.edu/~bcpierce/unison/download/releases/${P}/${P}.tar.gz
	doc? ( https://www.seas.upenn.edu/~bcpierce/unison/download/releases/${P}/${P}-manual.pdf
		https://www.seas.upenn.edu/~bcpierce/unison/download/releases/${P}/${P}-manual.html )"
S="${WORKDIR}"/src

src_prepare() {
	epatch "${FILESDIR}"/${PN}-2.48.4-Makefile-dep.patch
	default
}

src_compile() {
	local myconf

	if use threads; then
		myconf="$myconf THREADS=true"
	fi

	if use static; then
		myconf="$myconf STATIC=true"
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

src_install () {
	# install manually, since it's just too much
	# work to force the Makefile to do the right thing.
	newbin unison unison-${SLOT}
	dobin unison-fsmonitor
	dodoc BUGS.txt CONTRIB INSTALL NEWS \
		  README ROADMAP.txt TODO.txt

	if use doc; then
		dohtml "${DISTDIR}/${P}-manual.html"
		dodoc "${DISTDIR}/${P}-manual.pdf"
	fi
}

pkg_postinst() {
	elog "Unison now uses SLOTs, so you can specify servercmd=/usr/bin/unison-${SLOT}"
	elog "in your profile files to access exactly this version over ssh."
	elog "Or you can use 'eselect unison' to set the version."
	eselect unison update
}
