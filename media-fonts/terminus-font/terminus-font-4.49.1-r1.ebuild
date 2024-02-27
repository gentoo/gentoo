# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..12} )

inherit font python-any-r1

DESCRIPTION="A clean fixed font for the console and X11"
HOMEPAGE="https://terminus-font.sourceforge.net/"
SRC_URI="mirror://sourceforge/project/${PN}/${PN}-$(ver_cut 1-2)/${P}.tar.gz"

LICENSE="OFL-1.1 GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~loong ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~amd64-linux ~x86-linux ~ppc-macos"
IUSE="a-like-o +center-tilde distinct-l +otf pcf-8bit +pcf-unicode +psf quote
	ru-dv +ru-g ru-i ru-k"

BDEPEND="app-alternatives/gzip
	${PYTHON_DEPS}
	app-alternatives/awk
	pcf-8bit? ( x11-apps/bdftopcf )
	pcf-unicode? ( x11-apps/bdftopcf )"
RDEPEND=""

FONTDIR=/usr/share/fonts/terminus
FONT_CONF=( 75-yes-terminus.conf )
DOCS=( README README-BG AUTHORS CHANGES )

REQUIRED_USE="X? ( || ( otf pcf-8bit pcf-unicode ) )"

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
		$(usex otf otb "")
		$(usex pcf-8bit "pcf-8bit" "")
		$(usex pcf-unicode "pcf" "")
		$(usex psf "psf psf-vgaw" "")
	)
	[[ ${#args[@]} -gt 0 ]] && emake "${args[@]}"
}

src_install() {
	local args=(
		$(usex otf "install-otb" "")
		$(usex pcf-8bit "install-pcf-8bit" "")
		$(usex pcf-unicode "install-pcf" "")
		$(usex psf "install-psf install-psf-vgaw install-psf-ref" "")
	)
	# Set the CHECKDIR to a dummy location so we always get the same set of
	# files installed regardless of what is in / or ROOT or wherever.
	[[ ${#args[@]} -gt 0 ]] && emake DESTDIR="${D}" CHECKDIR="${D}" "${args[@]}"

	use otf && FONT_SUFFIX=otb font_src_install

	einstalldocs
}

pkg_postinst() {
	if use otf || use pcf-8bit || use pcf-unicode; then
		font_pkg_postinst
	fi
}

pkg_postrm() {
	if use otf || use pcf-8bit || use pcf-unicode; then
		font_pkg_postrm
	fi
}
