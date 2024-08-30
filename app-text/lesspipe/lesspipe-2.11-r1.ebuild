# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit edo

DESCRIPTION="Preprocessor for less"
HOMEPAGE="https://github.com/wofr06/lesspipe"
SRC_URI="https://github.com/wofr06/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x64-solaris"
IUSE="test"

# Please check again on bumps! (bug #734896)
RESTRICT="!test? ( test ) test"

RDEPEND="dev-lang/perl"
BDEPEND="
	${RDEPEND}
	virtual/pkgconfig
	test? ( app-editors/vim )
"

PATCHES=(
	# Backport patch to allow installing completions for shells that aren't
	# yet installed.
	#
	# https://github.com/wofr06/lesspipe/pull/142
	"${FILESDIR}"/all-completions.patch
)

src_configure() {
	# Not an autoconf script.
	#
	# PG0301
	# By default, only completions for installed shells are installed.
	# Unconditionally install zsh too.
	edo ./configure --prefix="${EPREFIX}"/usr --all-completions
}

src_compile() {
	# Nothing to build (avoids the "all" target)
	:
}

src_install() {
	emake PREFIX="${EPREFIX}/usr" DESTDIR="${D}" install
	einstalldocs

	# The upstream Makefile intentionally installs to the wrong directory, then prints:
	#   In bash, please preload the completion, dynamic invocation does not work
	#   . /usr/share/bash-completion/less_completion
	#   Or consider installing the file less_completion in /etc/bashcompletion.d
	rm "${ED}"/usr/share/bash-completion/less_completion || die
	rmdir "${ED}"/usr/share/bash-completion || die
	insinto /etc/bash_completion.d
	doins less_completion
}

pkg_preinst() {
	if [[ -z ${REPLACING_VERSIONS} ]] ; then
		elog "This package installs 'lesspipe.sh' which is distinct from 'lesspipe'."
		elog "The latter is the Gentoo-specific version.  Make sure to update your"
		elog "LESSOPEN environment variable if you wish to use this copy."
	fi
}
