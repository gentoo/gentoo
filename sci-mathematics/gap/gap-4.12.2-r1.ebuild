# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools

DESCRIPTION="System for computational discrete algebra. Core functionality."
HOMEPAGE="https://www.gap-system.org/"
SRC_URI="https://github.com/gap-system/gap/releases/download/v${PV}/${P}-core.tar.gz"

LICENSE="GPL-2+"
SLOT="0/8"
KEYWORDS="~amd64"
IUSE="cpu_flags_x86_popcnt debug emacs memcheck readline test valgrind"
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

# The test suite will fail without the "required" subset.
BDEPEND="test? ( ${REQUIRED_PKGS} )"

DEPEND="dev-libs/gmp:=
	sys-libs/zlib
	valgrind? ( dev-util/valgrind )
	readline? ( sys-libs/readline:= )"

RDEPEND="${DEPEND}"

# If you _really_ want to install GAP without the set of required
# packages, use package.provided.
PDEPEND="${REQUIRED_PKGS}"

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

	# Fix feature detection with pathological CFLAGS
	eautoreconf
}

src_configure() {
	# We unset $ABI because GAP uses it internally for something else.
	# --without-gmp and --without-zlib both trigger an AC_MSG_ERROR
	econf \
		ABI="" \
		--with-gmp \
		--with-zlib \
		$(use_enable cpu_flags_x86_popcnt popcnt) \
		$(use_enable memcheck memory-checking) \
		$(use_enable valgrind) \
		$(use_with readline) \
		$(use_enable debug)
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
	# required packages.
	emake GAPARGS="-A -l '${gaproots}'" check
}

src_install() {
	default

	# Manually install Makefile.gappkg
	insinto usr/share/gap/etc
	doins etc/Makefile.gappkg

	# la files removal
	find "${ED}" -type f -name '*.la' -delete || die
}
