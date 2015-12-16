# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="4"

inherit eutils

DESCRIPTION="Used to generate Makefile.in from Makefile.am"
HOMEPAGE="https://www.gnu.org/software/automake/"
SRC_URI="mirror://gnu/${PN}/${P}.tar.bz2"

LICENSE="GPL-2"
# Use Gentoo versioning for slotting.
SLOT="${PV:0:3}"
KEYWORDS="alpha amd64 arm arm64 hppa ia64 m68k ~mips ppc ppc64 s390 sh sparc x86 ~sparc-fbsd ~x86-fbsd"
IUSE=""

RDEPEND="dev-lang/perl
	>=sys-devel/automake-wrapper-10
	>=sys-devel/autoconf-2.69
	sys-devel/gnuconfig"
DEPEND="${RDEPEND}"

src_prepare() {
	export WANT_AUTOCONF=2.5
	epatch "${FILESDIR}"/${PN}-1.8.2-infopage-namechange.patch
	epatch "${FILESDIR}"/${P}-test-fixes.patch #159557
	epatch "${FILESDIR}"/${PN}-1.9.6-aclocal7-test-sleep.patch #197366
	epatch "${FILESDIR}"/${PN}-1.9.6-subst-test.patch #222225
	epatch "${FILESDIR}"/${PN}-1.10-ccnoco-ldflags.patch #203914
	epatch "${FILESDIR}"/${P}-CVE-2009-4029.patch #295357
	epatch "${FILESDIR}"/${PN}-1.8-perl-5.11.patch
}

# slot the info pages.  do this w/out munging the source so we don't have
# to depend on texinfo to regen things.  #464146 (among others)
slot_info_pages() {
	pushd "${D}"/usr/share/info >/dev/null
	rm -f dir

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

	popd >/dev/null
}

src_install() {
	default
	slot_info_pages
	rm -f "${D}"/usr/bin/{aclocal,automake}

	# remove all config.guess and config.sub files replacing them
	# w/a symlink to a specific gnuconfig version
	local x
	for x in guess sub ; do
		dosym ../gnuconfig/config.${x} /usr/share/${PN}-${SLOT}/config.${x}
	done
}
