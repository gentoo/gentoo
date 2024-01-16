# Copyright 2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# @ECLASS: gap-pkg.eclass
# @MAINTAINER:
# François Bissey <frp.bissey@gmail.com>
# Michael Orlitzky <mjo@gentoo.org>
# Gentoo Mathematics Project <sci-mathematics@gentoo.org>
# @AUTHOR:
# François Bissey <frp.bissey@gmail.com>
# Michael Orlitzky <mjo@gentoo.org>
# @SUPPORTED_EAPIS: 8
# @BLURB: Simplify the installation of GAP packages.
# @DESCRIPTION:
# The main purpose of this eclass is to build and install GAP packages
# that typically occupy the dev-gap category. Most GAP packages do not
# support an install target out of the box, so the default installation
# is "by hand," with attention paid to those directories that are part
# of the recommended layout. The prepare, configure, and compile phases
# do however try to support packages having a real build system.
#
# GAP itself has four "required" packages that are packaged separately,
# making dependencies between them somewhat weird. The four required
# packages are,
#
#   * dev-gap/gapdoc
#   * dev-gap/primgrp
#   * dev-gap/smallgrp
#   * dev-gap/transgrp
#
# Those four packages will have only sci-mathematics/gap added to
# RDEPEND. All other packages will have the four required packages above
# added to RDEPEND in addition to sci-mathematics/gap. In theory it
# would be better to list all dependencies explicitly rather than
# grouping together the "required" four, but this is how upstream GAP
# works, and is what all GAP packages expect; for example, most test
# suites fail without the required packages but make no attempt to load
# them.
#
# If you need a version constraint on sci-mathematics/gap, you'll have
# to specify it yourself. Compiled packages will likely need
# sci-mathematics/gap in DEPEND as well, and may also want a subslot
# dependency.

case ${EAPI} in
	8) ;;
	*) die "${ECLASS}: EAPI ${EAPI:-0} not supported" ;;
esac

# For eshopts_push and eshopts_pop
inherit estack

# Some packages have additional homepages, but pretty much every GAP
# package can be found at this URL.
HOMEPAGE="https://www.gap-system.org/Packages/${PN}.html"

# _GAP_PKG_IS_REQUIRED is an internal variable that indicates whether or
# not $PN is one of the four "required" GAP packages that are always
# loaded, even when GAP is started with the "-A" flag. We treat this
# four somewhat differently since they are implicit dependencies of
# everything else in the GAP ecosystem.
_GAP_PKG_IS_REQUIRED=no
case ${CATEGORY}/${PN} in
	 dev-gap/gapdoc|dev-gap/smallgrp|dev-gap/primgrp|dev-gap/transgrp)
		_GAP_PKG_IS_REQUIRED=yes
		;;
	 *)
		;;
esac

# _GAP_PKG_RDEPEND is an internal variable to hold the RDEPEND entries
# added by this eclass. We use a separate variable for this because we
# need its contents later in gap-pkg_enable_tests, and that function is
# called from an ebuild context where the list of RDEPEND is maintained
# separately. Basically: the values we add to RDEPEND here do not appear
# in RDEPEND when gap-pkg_enable_tests is called.
_GAP_PKG_RDEPEND="sci-mathematics/gap"

# The four "required" packages depend only on GAP itself, while every
# other package depends (also) on the four required ones.
if [[ "${_GAP_PKG_IS_REQUIRED}" = "no" ]]; then
	_GAP_PKG_RDEPEND+="
		dev-gap/gapdoc
		dev-gap/smallgrp
		dev-gap/primgrp
		dev-gap/transgrp"
fi
RDEPEND="${_GAP_PKG_RDEPEND}"

# @FUNCTION: gap-pkg_dir
# @DESCRIPTION:
# The directory into which the gap package should be installed. The
# accepted current location is /usr/$(get_libdir)/gap/pkg, but
# technically this depends on the econf call in sci-mathematics/gap.
gap-pkg_dir() {
	echo "/usr/$(get_libdir)/gap/pkg/${PN}"
}

# @FUNCTION: _gap-pkg_gaproot
# @INTERNAL
# @DESCRIPTION:
# The directory containing sysinfo.gap. This is frequently passed to GAP
# packages via ./configure --with-gaproot or as a positional argument to
# hand-written configure scripts. We also use it to find the value of
# $GAParch, which is contained in sysinfo.gap. The "gaproot" is
# implicitly determined by the econf call in sci-mathematics/gap. As a
# result, calling this function requires sci-mathematics/gap at
# build-time.
_gap-pkg_gaproot() {
	echo "${ESYSROOT}/usr/$(get_libdir)/gap"
}

# @FUNCTION: gap-pkg_econf
# @USAGE: [extra econf args]
# @DESCRIPTION:
# Call econf, passing the value of _gap-pkg_gaproot to --with-gaproot.
# All arguments to gap-pkg_econf are passed through to econf.
#
# @EXAMPLE
# src_configure() {
# 	gap-pkg_econf --with-external-libsemigroups
# }
#
gap-pkg_econf() {
	econf --with-gaproot="$(_gap-pkg_gaproot)" "${@}"
}

# @FUNCTION: gap-pkg_src_configure
# @DESCRIPTION:
# Handle both autoconf configure scripts and the hand-written ones used
# by many GAP packages. We determine which one we're dealing with by
# running ./configure --help; an autoconf configure script will mention
# "PREFIX" in the output, the others will not.
#
# Autoconf configure scripts are configured using gap-pkg_econf, while
# hand-written ones are executed directly with _gap-pkg_gaproot as their
# sole positional argument.
gap-pkg_src_configure() {
	local _configure="${ECONF_SOURCE:-.}/configure"
	if [[ -x ${_configure} ]] ; then
		if ${_configure} --help | grep PREFIX &>/dev/null; then
			# This is an autoconf ./configure script
			gap-pkg_econf
		else
			# It's an "old-style" handwritten script that does
			# not print usage information with --help.
			${_configure} $(_gap-pkg_gaproot) || die
		fi
	fi
}

# @FUNCTION: gap-pkg_src_compile
# @DESCRIPTION:
# The default src_compile with the addition of V=1 to emake. The
# Makefile.gappkg used to build most C packages defaults to a quiet
# build without this.
gap-pkg_src_compile() {
	if [[ -f Makefile ]] || [[ -f GNUmakefile ]] || [[ -f makefile ]]; then
		emake V=1 || die "emake failed"
	fi
}

# @FUNCTION: gap-pkg_enable_tests
# @DESCRIPTION:
# Amend IUSE, RESTRICT, and BDEPEND for a package with a test suite.
# This is modeled on similar functions in the distutils-r1 and
# elisp-common eclasses, except here only a single default testing
# strategy is supported. All runtime and post-merge dependencies are
# added as build dependencies if USE=test is set.
gap-pkg_enable_tests() {
	IUSE+=" test "
	RESTRICT+=" !test? ( test ) "

	# Use the internal variable here, too, because the RDEPEND list from
	# the ebuild is maintained separately by the package manager. We add
	# PDEPEND too because we use it to break some circular dependencies
	# between e.g. polycyclic and alnuth.
	BDEPEND+=" test? ( ${_GAP_PKG_RDEPEND} ${RDEPEND} ${PDEPEND} ) "
}

# @FUNCTION: gap-pkg_src_test
# @DESCRIPTION:
# Run this package's test suite if it has one. The GAP TestPackage
# function is the standard way to do this, but it does rely on the
# package itself to get a few things right, like running the tests
# verbosely and exiting with the appropriate code. The alternative would
# be run TestDirectory ourselves on "tst", but that has its own issues;
# in particular many packages have set-up code that is run only with
# TestPackage. YMMV.
gap-pkg_src_test() {
	[[ -f PackageInfo.g ]] || return

	# We would prefer --bare to -A so that we can test (say) primgrp
	# after installing only gapdoc and not smallgrp or transgrp. But,
	# that would cause problems for basically every non-required
	# package, because they usually don't explicitly load the four
	# "required" packages in their test suites. So we use -A unless
	# this is one of the chosen four.
	local bareflag="--bare"
	if [[ "${_GAP_PKG_IS_REQUIRED}" = "no" ]]; then
		bareflag="-A"
	fi

	# Run GAP non-interactively to test the just-built package. We omit
	# the "-r" flag here because we use the UserGapRoot directory to
	# store AtlasRep data, and without it, the atlasrep tests (and the
	# tests of any packages depending on it) will fail.
	local gapcmd="gap -R ${bareflag} --nointeract"

	# ForceQuitGap translates a boolean return value to the expected
	# zero or one, useful for packages that set a single *.tst file as
	# their TestFile.
	gapcmd+=" -c ForceQuitGap(TestPackage(\"${PN}\"));"

	# Fake the directory structure that GAP needs to be able to find
	# packages with a symlink under ${T}, then prepend ${T} to the list
	# of search paths so that if this package is already installed, we
	# load the just-built copy first.
	ln -s "${WORKDIR}" "${T}/pkg" || die
	gapcmd+=" --roots ${T}/; "

	# False negatives can occur if GAP fails to start, or if there are
	# syntax errors:
	#
	#   https://github.com/gap-system/gap/issues/5541
	#
	# There's nothing you can do about that, but now you know.
	#
	# The pipe to tee is more important than it looks. Any test suite
	# involving dev-gap/browse is likely to bork the user's terminal.
	# The "browse" package is however smart enough to figure out when
	# stdout is not a tty, and avoids breaking it in that case. So by
	# piping to tee, we encourage it not to do anything too crazy.
	${gapcmd} | tee test-suite.log \
		|| die "test suite failed, see test-suite.log"
}

# @ECLASS_VARIABLE: GAP_PKG_EXTRA_INSTALL
# @DEFAULT_UNSET
# @DESCRIPTION:
# A bash array of extra files and directories to install recursively at
# the root of this package's directory tree. For example, if you have a
# package that mostly follows the suggested layout (described in the
# gap-pkg_src_install documentation) but also includes a "data"
# directory, you should set
#
#   GAP_PKG_EXTRA_INSTALL=( data )
#
# to install the data directory without having to override the entire
# src_install phase.

# @ECLASS_VARIABLE: GAP_PKG_HTML_DOCDIR
# @DESCRIPTION:
# The directory inside the tarball where the HTML documentation is
# located. This is _usually_ "doc", which conforms to the suggested
# GAPDoc layout and is the default value of this variable. Many
# packages however use a top-level "htm" directory instead. The named
# directory will be installed to gap-pkg_dir and symlinked to the usual
# location under /usr/share/doc. As a result, you should only use this
# for directories referenced by PackageInfo.g or by some other part of
# the package. HTML documentation whose location doesn't need to be
# known to the package at runtime should instead be installed with
# HTML_DOCS or a similar mechanism.
: "${GAP_PKG_HTML_DOCDIR:=doc}"

# @FUNCTION: gap-pkg_src_install
# @DESCRIPTION:
# Install a GAP package that follows the suggested layout,
#
#   https://docs.gap-system.org/doc/ref/chap76.html
#
# In particular:
#
# 1. All GAP source files (*.g) in $S are installed.
#
# 2. If a library directory named "gap" or "lib" exists,
#    it is installed.
#
# 3. If a binary directory "bin" exists, it is installed.
#
# 4. If a "doc" directory exists, we assume GAPDoc conventions
#    (https://docs.gap-system.org/pkg/gapdoc/doc/chap5.html) and install
#    what we find there. Unfortunately for us, each package's
#    PackageInfo.g contains a "PackageDoc" section that points to this
#    documentation, and we can't break the paths it references. Instead,
#    we try to dosym the human-readable parts of the documentation (PDF
#    manuals) into appropriate Gentoo locations.
#
# 5. We consult GAP_PKG_HTML_DOCDIR for the HTML documentation and repeat
#    the process above.
#
# A few GAP packages have autotools build systems with working "make
# install" routines, but most don't. So for the time being we omit that
# step. It's harder to work around the packages that don't support it
# than the other way around.
gap-pkg_src_install() {
	einstalldocs

	# So we don't have to "test -f" on the result of every glob.
	eshopts_push -s nullglob

	# Install the "normal" documentation from the doc directory. This
	# includes anything the interactive GAP help might need in addition
	# to the documentation intended for direct user consumption.
	if [[ -d doc ]]; then
		pushd doc > /dev/null || die

		local docdir="$(gap-pkg_dir)/doc"
		insinto "${docdir}"

		# These files are needed by the GAP interface. We don't symlink
		# these because they're not meant for direct human consumption;
		# the text files are not *plain* text -- they contain color
		# codes. I'm not sure if the BibTeX files are actually used,
		# but the GAP packaging documentation mentions specifically
		# that they should be included. XML files are included in case
		# the bibliography is in BibXMLext format, but you may wind up
		# with some additional GAPDoc (XML) source files as a result.
		for f in *.{bib,lab,six,tex,txt,xml}; do
			doins "${f}"
		done

		# The PDF docs are also potentially used by the interface, since
		# they appear in PackageInfo.g, so we install them "as is." But
		# then afterwards we symlink them to their proper Gentoo
		# locations
		for f in *.pdf; do
			doins "${f}"
			dosym -r "${docdir}/${f}" "/usr/share/doc/${PF}/${f}"
		done

		popd > /dev/null || die
	fi

	# Install the HTML documentation. The procedure is basically the
	# same as for the PDF docs.
	if [[ -d "${GAP_PKG_HTML_DOCDIR}" ]]; then
		pushd "${GAP_PKG_HTML_DOCDIR}" > /dev/null || die

		local docdir="$(gap-pkg_dir)/${GAP_PKG_HTML_DOCDIR}"
		insinto "${docdir}"

		# See above
		for f in *.{htm,html,css,js,png}; do
			doins "${f}"
			dosym -r "${docdir}/${f}" "/usr/share/doc/${PF}/html/${f}"
		done

		popd > /dev/null || die
	fi

	# Any GAP source files that live in the top-level directory.
	insinto $(gap-pkg_dir)
	for f in *.g; do
		doins "${f}"
	done

	# We're done globbing
	eshopts_pop

	# The gap and lib dirs that usually also contain GAP code.
	[[ -d gap ]] && doins -r gap
	[[ -d lib ]] && doins -r lib

	# Any additional user-specified files or directories.
	for f in "${GAP_PKG_EXTRA_INSTALL[@]}"; do
		doins -r "${f}"
	done

	# The bin dir, that contains shared libraries but also sometimes
	# regular executables in an arch-specific subdirectory. We do
	# this last because it messes with insopts -- doexe doesn't work
	# recursively and we don't care what the subdirectory structure is.
	if [[ -d bin ]]; then
		insopts -m0755
		doins -r bin

		# Find and remove .la files from this package's bindir. The
		# usual "find" command doesn't work here because occasionally we
		# find *.la files in GAP packages that are not libtool archives
		# and should not be deleted.
		find "${ED%/}$(gap-pkg_dir)/bin" -type f -name '*.la' -delete || die
	fi
}

EXPORT_FUNCTIONS src_configure src_compile src_test src_install
