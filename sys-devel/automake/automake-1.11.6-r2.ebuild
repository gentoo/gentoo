# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="4"

inherit eutils

DESCRIPTION="Used to generate Makefile.in from Makefile.am"
HOMEPAGE="https://www.gnu.org/software/automake/"
SRC_URI="mirror://gnu/${PN}/${P}.tar.xz"

LICENSE="GPL-2"
# Use Gentoo versioning for slotting.
SLOT="${PV:0:4}"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~amd64-fbsd ~sparc-fbsd ~x86-fbsd"
IUSE=""

RDEPEND="dev-lang/perl
	>=sys-devel/automake-wrapper-10
	>=sys-devel/autoconf-2.69
	sys-devel/gnuconfig"
DEPEND="${RDEPEND}
	sys-apps/help2man"

src_prepare() {
	export WANT_AUTOCONF=2.5
	epatch "${FILESDIR}"/${PN}-1.10-perl-5.16.patch #424453
	epatch "${FILESDIR}"/${PN}-1.13-perl-escape-curly-bracket.patch
	chmod a+rx tests/*.test
}

src_configure() {
	econf --docdir=/usr/share/doc/${PF} HELP2MAN=true
}

src_compile() {
	emake APIVERSION="${SLOT}" pkgvdatadir="/usr/share/${PN}-${SLOT}"

	local x
	for x in aclocal automake; do
		help2man "perl -Ilib ${x}" > doc/${x}-${SLOT}.1
	done
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
	emake DESTDIR="${D}" install \
		APIVERSION="${SLOT}" pkgvdatadir="/usr/share/${PN}-${SLOT}"
	slot_info_pages
	dodoc NEWS README THANKS TODO AUTHORS ChangeLog

	rm \
		"${D}"/usr/bin/{aclocal,automake} \
		"${D}"/usr/share/man/man1/{aclocal,automake}.1 || die

	# remove all config.guess and config.sub files replacing them
	# w/a symlink to a specific gnuconfig version
	local x
	for x in guess sub ; do
		dosym ../gnuconfig/config.${x} /usr/share/${PN}-${SLOT}/config.${x}
	done
}
