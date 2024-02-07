# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit estack

DESCRIPTION="System for computational discrete algebra. Core functionality."
HOMEPAGE="https://www.gap-system.org/"
SRC_URI="https://github.com/gap-system/gap/releases/download/v${PV/_/-}/${P/_/-}-core.tar.gz"

LICENSE="GPL-2+"
SLOT="0/9" # soname
KEYWORDS=""
IUSE="cpu_flags_x86_popcnt debug memcheck minimal readline test valgrind"
REQUIRED_USE="?? ( memcheck valgrind )"
RESTRICT="!test? ( test )"

# The minimum set of packages needed for basic GAP operation. You can
# actually start gap without these by passing "--bare" to it on the CLI,
# but don't expect anything to work.
REQUIRED_PKGS="
	dev-gap/gapdoc
	dev-gap/primgrp
	dev-gap/smallgrp
	dev-gap/transgrp"

# The packages aren't really required, but GAP tries to load them
# automatically, and will complain to the user if they fail to load.
# The list of automatically-loaded packages is a user preference, called
# AutoloadPackages, and the upstream default can be found in
# lib/package.gi within the GAP source tree. Passing "-A" to GAP on the
# CLI (or setting that user preference) will suppress the autoload
# behavior and allow GAP to start without these, which is why we allow
# the user to skip them with USE=minimal if he knows what he is doing.
AUTOLOADED_PKGS="
	dev-gap/autpgrp
	dev-gap/alnuth
	dev-gap/crisp
	dev-gap/ctbllib
	dev-gap/factint
	dev-gap/fga
	dev-gap/irredsol
	dev-gap/laguna
	dev-gap/polenta
	dev-gap/polycyclic
	dev-gap/resclasses
	dev-gap/sophus
	dev-gap/tomlib"

# The test suite will fail without the "required" subset.
BDEPEND="test? ( ${REQUIRED_PKGS} )"

DEPEND="dev-libs/gmp:=
	sys-libs/zlib
	valgrind? ( dev-debug/valgrind )
	readline? ( sys-libs/readline:= )"

RDEPEND="${DEPEND}"

# If you _really_ want to install GAP without the set of required
# packages, use package.provided.
PDEPEND="${REQUIRED_PKGS} !minimal? ( ${AUTOLOADED_PKGS} )"

S="${WORKDIR}/${P/_/-}"

pkg_setup() {
	if use valgrind; then
		elog "If you enable the use of valgrind during building"
		elog "be sure that you have enabled the proper flags"
		elog "in gcc to support it:"
		elog "https://wiki.gentoo.org/wiki/Debugging#Valgrind"
	fi
}

src_prepare() {
	# Remove these to be extra sure we don't use bundled libraries.
	rm -r extern || die
	rm -r hpcgap/extern || die

	# The Makefile just tells you to run ./configure, which then
	# produces a GNUmakefile.
	rm Makefile || die

	default
}

src_configure() {
	# We unset $ABI because GAP uses it internally for something else.
	# --without-gmp and --without-zlib both trigger an AC_MSG_ERROR
	local myeconfargs=(
		ABI=""
		--with-gmp
		--with-zlib
		$(use_enable cpu_flags_x86_popcnt popcnt)
		$(use_enable memcheck memory-checking)
		$(use_enable valgrind)
		$(use_with readline)
		$(use_enable debug)
	)
	econf "${myeconfargs[@]}"
}

src_compile() {
	# Without this, the default is a quiet build.
	emake V=1
}

src_test() {
	# We need to specify additional root paths because otherwise the
	# recently-built GAP doesn't know where to look for the "required"
	# packages (which must already be installed). The two paths we
	# append to $S are where those packages wind up.
	local gaproots="${S}/;"
	gaproots+="${EPREFIX}/usr/$(get_libdir)/gap/;"
	gaproots+="${EPREFIX}/usr/share/gap/"

	# GAPARGS is a Makefile variable that exists for this purpose. We
	# use "-A" to hide the warnings about missing autoloaded-but-not-
	# required packages. The tee/pipefail works around a glitch in
	# dev-gap/browse that can clobber your terminal.
	eshopts_push -o pipefail
	emake GAPARGS="-A -l '${gaproots}'" check | tee test-suite.log \
		|| die "test suite failed, see test-suite.log"
	eshopts_pop
}

src_install() {
	default

	# Manually install Makefile.gappkg
	insinto usr/share/gap/etc
	doins etc/Makefile.gappkg

	# la files removal
	find "${ED}" -type f -name '*.la' -delete || die
}
