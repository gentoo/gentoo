# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit eutils font

DESCRIPTION="A clean fixed font for the console and X11"
HOMEPAGE="http://terminus-font.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}/${P}.tar.gz"

LICENSE="OFL-1.1 GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 arm ~arm64 hppa ia64 ~mips ppc ppc64 ~s390 ~sh sparc x86 ~x86-fbsd ~x86-freebsd ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos"
IUSE="a-like-o +center-tilde distinct-l +pcf +pcf-unicode-only +psf quote
	raw-font-data ru-dv +ru-g ru-i ru-k"

DEPEND="app-arch/gzip
	dev-lang/perl
	virtual/awk
	pcf? ( x11-apps/bdftopcf )"
RDEPEND=""

FONTDIR=/usr/share/fonts/terminus
FONT_CONF=( 75-yes-terminus.conf )
DOCS="README README-BG AUTHORS CHANGES"

REQUIRED_USE="X? ( pcf )"

src_prepare() {
	# Upstream patches. Some of them are suggested to be applied by default
	# dv - de NOT like latin g, but like caps greek delta
	#      ve NOT like greek beta, but like caps latin B
	# ge - ge NOT like "mirrored" latin s, but like caps greek gamma
	# ka - small ka NOT like minimised caps latin K, but like small latin k
	use a-like-o && epatch "${S}"/alt/ao2.diff
	use center-tilde && epatch "${S}"/alt/td1.diff
	use distinct-l && epatch "${S}"/alt/ll2.diff
	use ru-i     && epatch "${S}"/alt/ij1.diff
	use ru-k     && epatch "${S}"/alt/ka2.diff
	use ru-dv    && epatch "${S}"/alt/dv1.diff
	use ru-g     && epatch "${S}"/alt/ge2.diff
	use quote    && epatch "${S}"/alt/gq2.diff
}

src_configure() {
	# selfwritten configure script without executable bit
	chmod +x ./configure || die
	./configure \
		--prefix="${EPREFIX}"/usr \
		--psfdir="${EPREFIX}"/usr/share/consolefonts \
		--acmdir="${EPREFIX}"/usr/share/consoletrans \
		--unidir="${EPREFIX}"/usr/share/consoletrans \
		--x11dir="${EPREFIX}"/${FONTDIR} || die
}

src_compile() {
	local args=(
		$(usex psf 'psf txt' '')
		$(usex raw-font-data 'raw' '')
		$(usex pcf 'pcf' '')
	)
	[[ ${#args[@]} -gt 0 ]] && emake "${args[@]}"
}

src_install() {
	local args=(
		$(usex psf 'install-psf install-uni install-acm install-ref' '')
		$(usex raw-font-data 'install.raw' '')
		$(usex pcf 'install-pcf' '')
	)
	# Set the CHECKDIR to a dummy location so we always get the same set of
	# files installed regardless of what is in / or ROOT or wherever.
	[[ ${#args[@]} -gt 0 ]] && emake DESTDIR="${D}" CHECKDIR="${D}" "${args[@]}"

	# Remove trans files that the kbd package takes care of installing.
	rm -f "${ED}"/usr/share/consoletrans/*.trans

	if use pcf-unicode-only; then
		# Only the ter-x* fonts are unicode (ISO-10646-1) based
		rm -f "${ED}"/usr/share/fonts/terminus/ter-[0-9a-wy-z]* || die
	fi

	font_src_install
}
