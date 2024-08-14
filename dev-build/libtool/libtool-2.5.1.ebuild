# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# Please bump with dev-libs/libltdl.

# bug #225559
LIBTOOLIZE="true"
WANT_LIBTOOL="none"
inherit autotools flag-o-matic prefix multiprocessing

if [[ ${PV} == *9999 ]] ; then
	EGIT_REPO_URI="https://git.savannah.gnu.org/git/libtool.git"
	inherit git-r3
elif ! [[ $(( $(ver_cut 2) % 2 )) -eq 0 ]] ; then
	SRC_URI="https://alpha.gnu.org/gnu/${PN}/${P}.tar.xz"
else
	SRC_URI="mirror://gnu/${PN}/${P}.tar.xz"
	KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~loong ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~amd64-linux ~x86-linux ~arm64-macos ~ppc-macos ~x64-macos ~x64-solaris"
fi

DESCRIPTION="A shared library tool for developers"
HOMEPAGE="https://www.gnu.org/software/libtool/"

LICENSE="GPL-2"
SLOT="2"
IUSE="vanilla"

# Pull in libltdl directly until we convert packages to the new dep.
RDEPEND="
	sys-devel/gnuconfig
	>=dev-build/autoconf-2.69:*
	>=dev-build/automake-1.13:*
"
DEPEND="${RDEPEND}"
[[ ${PV} == *9999 ]] && BDEPEND="sys-apps/help2man"

# Note that we have more patches in https://gitweb.gentoo.org/proj/elt-patches.git/
# for package builds. The patches here are just those which are definitely fine
# for the system-wide libtool installation as well.
PATCHES=(
	# bug #109105
	"${FILESDIR}"/${PN}-2.4.3-use-linux-version-in-fbsd.patch
	# bug #581314
	"${FILESDIR}"/${PN}-2.4.6-ppc64le.patch

	"${FILESDIR}"/${PN}-2.2.6a-darwin-module-bundle.patch
	"${FILESDIR}"/${PN}-2.4.6-darwin-use-linux-version.patch
)

src_prepare() {
	if [[ ${PV} == *9999 ]] ; then
		eapply "${FILESDIR}"/${PN}-2.4.6-pthread.patch # bug #650876
		./bootstrap || die
	else
		PATCHES+=(
			"${FILESDIR}"/${PN}-2.4.6-pthread_bootstrapped.patch # bug #650876
		)
	fi

	# WARNING: File build-aux/ltmain.sh is read-only; trying to patch anyway
	chmod +w build-aux/ltmain.sh || die

	if use vanilla ; then
		eapply_user
		return 0
	else
		default
	fi

	if use prefix ; then
		# seems that libtool has to know about EPREFIX a little bit
		# better, since it fails to find prefix paths to search libs
		# from, resulting in some packages building static only, since
		# libtool is fooled into thinking that libraries are unavailable
		# (argh...). This could also be fixed by making the gcc wrapper
		# return the correct result for -print-search-dirs (doesn't
		# include prefix dirs ...).
		eapply "${FILESDIR}"/${PN}-2.2.10-eprefix.patch
		eprefixify m4/libtool.m4
	fi

	pushd libltdl >/dev/null || die
	AT_NOELIBTOOLIZE=yes eautoreconf
	popd >/dev/null || die
	AT_NOELIBTOOLIZE=yes eautoreconf

	# Make sure timestamps don't trigger a rebuild of man pages. #556512
	if [[ ${PV} != *9999 ]] ; then
		touch doc/*.1 || die
		export HELP2MAN=true
	fi
}

src_configure() {
	# the libtool script uses bash code in it and at configure time, tries
	# to find a bash shell.  if /bin/sh is bash, it uses that.  this can
	# cause problems for people who switch /bin/sh on the fly to other
	# shells, so just force libtool to use /bin/bash all the time.
	# Do not bother hardcoding the full path to sed.
	# Just rely on $PATH. bug #574550
	export CONFIG_SHELL="${EPREFIX}"/bin/bash
	export ac_cv_path_SED="sed"
	export ac_cv_path_EGREP="grep -E"
	export ac_cv_path_EGREP_TRADITIONAL="grep -E"
	export ac_cv_path_FGREP="grep -F"
	export ac_cv_path_GREP="grep"
	export ac_cv_path_lt_DD="dd"

	local myeconfargs=(
		# Split into dev-libs/libltdl
		--disable-ltdl-install

		# Tests break otherwise (when porting to EAPI 8)
		# https://lists.gnu.org/archive/html/bug-libtool/2014-10/msg00013.html
		--enable-static
	)

	[[ ${CHOST} == *-darwin* ]] && myeconfargs+=( "--program-prefix=g" )

	ECONF_SOURCE="${S}" econf "${myeconfargs[@]}"
}

src_test() {
	(
		# The testsuite is sensitive to warnings, expects static
		# archives to really be archives (not compiler IR), etc.
		strip-flags
		filter-flags -fno-semantic-interposition
		filter-flags '-Wstrict-aliasing=*' '-Werror=*'
		filter-lto

		emake -Onone check \
			CFLAGS="${CFLAGS}" \
			CXXFLAGS="${CXXFLAGS}" \
			FFLAGS="${FFLAGS}" \
			FCFLAGS="${FCFLAGS}" \
			LDFLAGS="${LDFLAGS}" \
			TESTSUITEFLAGS="--jobs=$(get_makeopts_jobs)"
	)
}

src_install() {
	default

	local x
	while read -d $'\0' -r x ; do
		ln -sf "${EPREFIX}"/usr/share/gnuconfig/${x##*/} "${x}" || die
	done < <(find "${ED}" '(' -name config.guess -o -name config.sub ')' -print0)
}
