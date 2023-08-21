# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit edo bash-completion-r1

DESCRIPTION="Preprocessor for less"
HOMEPAGE="https://github.com/wofr06/lesspipe"
SRC_URI="https://github.com/wofr06/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x64-solaris"
IUSE="test"

# Please check again on bumps!
# bug #734896
RESTRICT="!test? ( test ) test"

RDEPEND="dev-lang/perl"
BDEPEND="
	${RDEPEND}
	virtual/pkgconfig
	test? ( app-editors/vim )
"

src_configure() {
	# Not an autoconf script.
	edo ./configure --prefix="${EPREFIX}"/usr
}

src_compile() {
	# Nothing to build (avoids the "all" target)
	:
}

src_install() {
	emake PREFIX="${EPREFIX}/usr" DESTDIR="${D}" install
	einstalldocs

	rm "${ED}"/usr/share/bash-completion/less_completion || die
	newbashcomp less_completion less
}

pkg_preinst() {
	if [[ -z ${REPLACING_VERSIONS} ]] ; then
		elog "This package installs 'lesspipe.sh' which is distinct from 'lesspipe'."
		elog "The latter is the Gentoo-specific version.  Make sure to update your"
		elog "LESSOPEN environment variable if you wish to use this copy."
	fi
}
