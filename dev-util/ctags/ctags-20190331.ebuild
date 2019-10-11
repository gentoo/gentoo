# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit autotools

COMMITHASH="95975bd157cc1326120977ce530f0477bcbf43b1"

DESCRIPTION="Exuberant Ctags creates tags files for code browsing in editors"
HOMEPAGE="https://ctags.io/ https://github.com/universal-ctags/ctags"
SRC_URI="https://github.com/universal-ctags/ctags/archive/${COMMITHASH}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="alpha amd64 arm arm64 hppa ia64 ~m68k ~mips ppc ppc64 s390 ~sh sparc x86 ~ppc-aix ~x64-cygwin ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~m68k-mint ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE="json xml yaml"

CDEPEND="
	json? ( dev-libs/jansson )
	xml? ( dev-libs/libxml2:2 )
	yaml? ( dev-libs/libyaml )"

RDEPEND="
	${CDEPEND}
	app-eselect/eselect-ctags"

DEPEND="
	${CDEPEND}
	dev-python/docutils
	virtual/pkgconfig"

S="${WORKDIR}/${PN}-${COMMITHASH}"

src_prepare() {
	default
	./misc/dist-test-cases > makefiles/test-cases.mak || die
	eautoreconf
}

src_configure() {
	econf \
		$(use_enable json) \
		$(use_enable xml) \
		$(use_enable yaml) \
		--disable-readlib \
		--disable-etags \
		--enable-tmpdir="${EPREFIX}"/tmp
}

src_install() {
	emake prefix="${ED}"/usr mandir="${ED}"/usr/share/man install

	# namepace collision with X/Emacs-provided /usr/bin/ctags -- we
	# rename ctags to exuberant-ctags (Mandrake does this also).
	mv "${ED}"/usr/bin/{ctags,exuberant-ctags} || die
	mv "${ED}"/usr/share/man/man1/{ctags,exuberant-ctags}.1 || die
}

pkg_postinst() {
	eselect ctags update

	if [[ -z "$REPLACING_VERSIONS" ]]; then
		elog "You can set the version to be started by /usr/bin/ctags through"
		elog "the ctags eselect module. \"man ctags.eselect\" for details."
	fi
}

pkg_postrm() {
	eselect ctags update
}
