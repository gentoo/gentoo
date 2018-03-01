# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="6"
PYTHON_COMPAT=( python2_7 )

inherit python-any-r1

DESCRIPTION="Used to generate Makefile.in from Makefile.am"
HOMEPAGE="https://www.gnu.org/software/automake/"
SRC_URI="mirror://gnu/${PN}/${P}.tar.bz2"

LICENSE="GPL-2"
# Use Gentoo versioning for slotting.
SLOT="${PV:0:3}"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~amd64-fbsd ~x86-fbsd"
IUSE="test"

RDEPEND="dev-lang/perl
	>=sys-devel/automake-wrapper-10
	>=sys-devel/autoconf-2.69:*
	>=sys-apps/texinfo-4.7
	sys-devel/gnuconfig"
DEPEND="${RDEPEND}
	sys-apps/help2man
	test? ( ${PYTHON_DEPS} )"

PATCHES=(
	"${FILESDIR}"/${PN}-1.9.6-infopage-namechange-r1.patch
	"${FILESDIR}"/${P}-include-dir-prefix-r1.patch #107435
	"${FILESDIR}"/${P}-ignore-comments-r1.patch #126388
	"${FILESDIR}"/${P}-aclocal7-test-sleep.patch #197366
	"${FILESDIR}"/${PN}-1.9.6-subst-test.patch #222225
	"${FILESDIR}"/${PN}-1.10-ccnoco-ldflags.patch #203914
	"${FILESDIR}"/${PN}-1.8.5-CVE-2009-4029.patch #295357
	"${FILESDIR}"/${PN}-1.8-perl-5.11.patch
)

src_prepare() {
	default
	export WANT_AUTOCONF=2.5
}

# slot the info pages.  do this w/out munging the source so we don't have
# to depend on texinfo to regen things.  #464146 (among others)
slot_info_pages() {
	pushd "${ED%/}"/usr/share/info >/dev/null || die
	rm -f dir || die

	# Rewrite all the references to other pages.
	# before: * aclocal-invocation: (automake)aclocal Invocation.   Generating aclocal.m4.
	# after:  * aclocal-invocation v1.13: (automake-1.13)aclocal Invocation.   Generating aclocal.m4.
	local p pages=( *.info ) args=()
	for p in "${pages[@]/%.info}" ; do
		args+=(
			-e "/START-INFO-DIR-ENTRY/,/END-INFO-DIR-ENTRY/s|: (${p})| v${SLOT}&|"
			-e "s:(${p}):(${p}-${SLOT}):g"
		)
	done
	sed -i "${args[@]}" * || die

	# Rewrite all the file references, and rename them in the process.
	local f d
	for f in * ; do
		d=${f/.info/-${SLOT}.info}
		mv "${f}" "${d}" || die
		sed -i -e "s:${f}:${d}:g" * || die
	done

	popd >/dev/null || die
}

src_test() {
	python_setup

	default
}

src_install() {
	default
	slot_info_pages

	local x
	for x in aclocal automake ; do
		help2man "perl -Ilib ${x}" > ${x}-${SLOT}.1
		doman ${x}-${SLOT}.1
		rm -f "${ED%/}"/usr/bin/${x}
	done

	# remove all config.guess and config.sub files replacing them
	# w/a symlink to a specific gnuconfig version
	for x in guess sub ; do
		dosym ../gnuconfig/config.${x} /usr/share/${PN}-${SLOT}/config.${x}
	done
}
