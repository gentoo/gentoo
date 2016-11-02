# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

DESCRIPTION="Exuberant Ctags creates tags files for code browsing in editors"
HOMEPAGE="https://ctags.io/ https://github.com/universal-ctags/ctags"
SRC_URI="http://dev.gentoo.org/~radhermit/vim/${P}.tar.xz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~amd64-fbsd ~sparc-fbsd ~x86-fbsd ~ppc-aix ~x64-freebsd ~x86-freebsd ~hppa-hpux ~ia64-hpux ~x86-interix ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~m68k-mint ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE="json xml yaml"

COMMON_DEPEND="
	json? ( dev-libs/jansson )
	xml? ( dev-libs/libxml2:2 )
	yaml? ( dev-libs/libyaml )
"
RDEPEND="
	${COMMON_DEPEND}
	app-eselect/eselect-ctags
"
DEPEND="
	${COMMON_DEPEND}
	dev-python/docutils
	virtual/pkgconfig
"

PATCHES=( "${FILESDIR}"/${P}-automagic-deps.patch )

src_prepare() {
	default
	./autogen.sh || die
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
