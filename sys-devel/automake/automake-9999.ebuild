# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="4"

EGIT_REPO_URI="git://git.savannah.gnu.org/${PN}.git
	http://git.savannah.gnu.org/r/${PN}.git"

inherit eutils git-2

DESCRIPTION="Used to generate Makefile.in from Makefile.am"
HOMEPAGE="https://www.gnu.org/software/automake/"
SRC_URI=""

LICENSE="GPL-3"
# Use Gentoo versioning for slotting.
SLOT="${PV:0:4}"
KEYWORDS=""
IUSE=""

RDEPEND="dev-lang/perl
	>=sys-devel/automake-wrapper-9
	>=sys-devel/autoconf-2.69
	>=sys-apps/texinfo-4.7
	sys-devel/gnuconfig"
DEPEND="${RDEPEND}
	sys-apps/help2man"

src_prepare() {
	export WANT_AUTOCONF=2.5
	# Don't try wrapping the autotools this thing runs as it tends
	# to be a bit esoteric, and the script does `set -e` itself.
	./bootstrap.sh
}

src_configure() {
	econf --docdir=/usr/share/doc/${PF}
}

src_test() {
	emake check
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

	# SLOT the docs and junk
	local x
	for x in aclocal automake ; do
		help2man "perl -Ilib ${x}" > ${x}-${SLOT}.1
		doman ${x}-${SLOT}.1
		rm -f "${D}"/usr/bin/${x}
	done

	# remove all config.guess and config.sub files replacing them
	# w/a symlink to a specific gnuconfig version
	for x in guess sub ; do
		dosym ../gnuconfig/config.${x} /usr/share/${PN}-${SLOT}/config.${x}
	done
}
