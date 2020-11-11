# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6,7,8,9} )
inherit font python-any-r1

DESCRIPTION="A clean fixed font for the console and X11"
HOMEPAGE="http://terminus-font.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}/${P}.tar.gz"

LICENSE="OFL-1.1 GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~ia64 ~mips ppc ppc64 ~s390 ~sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos"
IUSE="a-like-o +center-tilde distinct-l otf +pcf +pcf-unicode-only +psf quote
	ru-dv +ru-g ru-i ru-k"

DEPEND="app-arch/gzip
	${PYTHON_DEPS}
	virtual/awk
	otf? ( media-gfx/fontforge )
	pcf? ( x11-apps/bdftopcf )"
RDEPEND=""

FONTDIR=/usr/share/fonts/terminus
FONT_CONF=( 75-yes-terminus.conf )
DOCS=( README README-BG AUTHORS CHANGES )

REQUIRED_USE="X? ( pcf )"

pkg_setup() {
	python_setup
}

src_prepare() {
	default

	# Upstream patches. Some of them are suggested to be applied by default
	# dv - de NOT like latin g, but like caps greek delta
	#      ve NOT like greek beta, but like caps latin B
	# ge - ge NOT like "mirrored" latin s, but like caps greek gamma
	# ka - small ka NOT like minimised caps latin K, but like small latin k
	use a-like-o 		&& eapply "${S}"/alt/ao2.diff
	use center-tilde 	&& eapply "${S}"/alt/td1.diff
	use distinct-l 		&& eapply "${S}"/alt/ll2.diff
	use ru-i     		&& eapply "${S}"/alt/ij1.diff
	use ru-k     		&& eapply "${S}"/alt/ka2.diff
	use ru-dv    		&& eapply "${S}"/alt/dv1.diff
	use ru-g     		&& eapply "${S}"/alt/ge2.diff
	use quote    		&& eapply "${S}"/alt/gq2.diff
}

src_configure() {
	local configure_args=(
		--prefix="${EPREFIX}"/usr
		--psfdir="${EPREFIX}"/usr/share/consolefonts
		--x11dir="${EPREFIX}"/${FONTDIR}
	)
	# selfwritten configure script
	./configure "${configure_args[@]}" || die
}

src_compile() {
	local args=(
		$(usex psf 'psf psf-vgaw' '')
		$(usex pcf 'pcf pcf-8bit' '')
	)
	[[ ${#args[@]} -gt 0 ]] && emake "${args[@]}"

	# Follow https://bugs.gentoo.org/728308#c5
	# build ".otf" (bitmap-only) fonts out of .bdf ones
	#
	# Important details (copying notes as-is):
	#
	# 0. Pango 1.44 now returns floating point ascent and
	# descent, instead of integer. The functions were always returning float,
	# all right... but so far, without a fractional part. Which makes problems
	# too, for example in Scintilla based editors such as SciTE and Geany
	# (there is a quick and dirty fix).
	#
	# 1. 'fonttosfnt' adds 0.5 to at least the logical (OpenType-scaled)
	# character width, ascent and height. Haven't checked the physical (pixel)
	# metrics yet. With some sizes/applications, the fonttosfnt converted
	# fonts do indeed have extra wrong spacing, 1 pixel horizontal or
	# vertical. It has other bugs too, but they don't seem important.
	#
	# 2. If you pack 2+ terminus sizes into a single .otb font file, KDE will
	# (may? YMMV) use *only the first size*.
	#
	# 3. OTB has a single set of logical metrics. So, for example, the logical
	# character width (which is relative to height) can never be correct for
	# an .otb file including both 8x14 and 8x16.

	if use otf; then
		local source_bdf
		for source_bdf in ter-u*n.bdf ter-u*b.bdf; do
			set -- 	fontforge -lang=ff -c 'Open($1); ScaleToEm(1024); Generate($2)' \
				"${source_bdf}" "${source_bdf%.bdf}.otb"
			einfo "$@"
			"$@" || die
		done
	fi

}

src_install() {
	local args=(
		$(usex psf 'install-psf install-psf-vgaw install-psf-ref' '')
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

	use otf && FONT_SUFFIX=otb
	font_src_install

	einstalldocs
}
