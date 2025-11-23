# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs

MY_P="${P/_p/-r}"
DESCRIPTION="Design system for interactive fiction"
HOMEPAGE="https://www.inform-fiction.org/"
SRC_URI="https://ifarchive.org/if-archive/infocom/compilers/inform6/source/${MY_P}.tar.gz"
S="${WORKDIR}/${MY_P}"

LICENSE="Artistic-2 Inform"
SLOT="0"
KEYWORDS="amd64 ~ppc ~sparc x86 ~amd64-linux ~x86-linux ~ppc-macos"
IUSE="emacs tools"
# non-interactive tests use ruby, seem broken, and return true even on failure
RESTRICT="test"

RDEPEND="
	tools? (
		dev-lang/perl
		dev-perl/DateTime
	)"
PDEPEND="emacs? ( app-emacs/inform-mode )"

src_compile() {
	tc-export CC

	emake PREFIX="${EPREFIX}"/usr OPTS="${CFLAGS} ${CPPFLAGS}"
}

src_install() {
	local emakeargs=(
		PREFIX="${ED}"/usr
		REAL_PREFIX="${EPREFIX}"/usr
		MANDIR="${ED}"/usr/share/man/man1
		PUNYDOCS="${ED}"/usr/share/doc/${PF}/punyinform
		PUNYTESTS="${T}" # don't install tests
	)

	emake -j1 "${emakeargs[@]}" install

	dodoc AUTHORS NEWS README.md VERSION docs/README*

	if ! use tools; then
		rm "${ED}"/usr/bin/*blorb* || die
	fi

	find "${ED}"/usr/share/doc \( -name Makefile -o -name 'custom.*' \) -delete || die
}
