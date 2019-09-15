# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5
inherit autotools eutils flag-o-matic

DESCRIPTION="Advanced Linux Sound Architecture tools"
HOMEPAGE="https://alsa-project.org/"
SRC_URI="https://www.alsa-project.org/files/pub/tools/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0.9"
KEYWORDS="amd64 ~mips ppc ppc64 sparc x86"

IUSE="fltk gtk alsa_cards_hdsp alsa_cards_hdspm alsa_cards_mixart
alsa_cards_vx222 alsa_cards_usb-usx2y alsa_cards_sb16 alsa_cards_sbawe
alsa_cards_emu10k1 alsa_cards_emu10k1x alsa_cards_ice1712
alsa_cards_rme32 alsa_cards_rme96 alsa_cards_sscape alsa_cards_pcxhr"

COMMON_DEPEND=">=media-libs/alsa-lib-${PV}
	>=dev-python/pyalsa-1.0.26
	fltk? ( >=x11-libs/fltk-1.3.0:1 )
	gtk? (
		>=dev-python/pygtk-2
		x11-libs/gtk+:2
		x11-libs/gtk+:3
		)" #468294
RDEPEND="${COMMON_DEPEND}
	gtk? ( media-fonts/font-misc-misc )" #456114
DEPEND="${COMMON_DEPEND}
	virtual/pkgconfig"

pkg_setup() {
	ALSA_TOOLS="seq/sbiload us428control hwmixvolume hda-verb"

	if use gtk; then
		ALSA_TOOLS="${ALSA_TOOLS} hdajackretask"
		use alsa_cards_ice1712 && \
			ALSA_TOOLS="${ALSA_TOOLS} envy24control"
		use alsa_cards_rme32 && use alsa_cards_rme96 && \
			ALSA_TOOLS="${ALSA_TOOLS} rmedigicontrol"
	fi

	if use alsa_cards_hdsp || use alsa_cards_hdspm; then
		ALSA_TOOLS="${ALSA_TOOLS} hdsploader"
		use fltk && ALSA_TOOLS="${ALSA_TOOLS} hdspconf hdspmixer"
	fi

	use alsa_cards_mixart && ALSA_TOOLS="${ALSA_TOOLS} mixartloader"
	use alsa_cards_vx222 && ALSA_TOOLS="${ALSA_TOOLS} vxloader"
	use alsa_cards_usb-usx2y && ALSA_TOOLS="${ALSA_TOOLS} usx2yloader"
	use alsa_cards_pcxhr && ALSA_TOOLS="${ALSA_TOOLS} pcxhr"
	use alsa_cards_sscape && ALSA_TOOLS="${ALSA_TOOLS} sscape_ctl"

	{ use alsa_cards_sb16 || use alsa_cards_sbawe; } && \
		ALSA_TOOLS="${ALSA_TOOLS} sb16_csp"

	if use alsa_cards_emu10k1 || use alsa_cards_emu10k1x; then
		ALSA_TOOLS="${ALSA_TOOLS} as10k1 ld10k1"
	fi

	use gtk && ALSA_TOOLS="${ALSA_TOOLS} echomixer"
}

src_prepare() {
	epatch "${FILESDIR}"/envy24control-config-dir.patch

	epatch_user

	# This block only deals with the tools that still use GTK and the
	# AM_PATH_GTK macro.
	for dir in echomixer envy24control rmedigicontrol; do
		has "${dir}" "${ALSA_TOOLS}" || continue
		pushd "${dir}" &> /dev/null
		eautoreconf
		popd &> /dev/null
	done

	# This block deals with the tools that are being patched
	for dir in hdspconf; do
		has "${dir}" "${ALSA_TOOLS}" || continue
		pushd "${dir}" &> /dev/null
		eautoreconf
		popd &> /dev/null
	done

	elibtoolize
}

src_configure() {
	if use fltk; then
		# hdspmixer requires fltk
		append-ldflags "-L$(dirname $(fltk-config --libs))"
		append-flags "-I$(fltk-config --includedir)"
	fi

	local f
	for f in ${ALSA_TOOLS}
	do
		cd "${S}/${f}"
		case "${f}" in
			echomixer,envy24control,rmedigicontrol )
				econf --with-gtk2
				;;
			* )
				econf
				;;
		esac
	done
}

src_compile() {
	local f
	for f in ${ALSA_TOOLS}
	do
		cd "${S}/${f}"
		emake
	done
}

src_install() {
	local f
	for f in ${ALSA_TOOLS}
	do
		# Install the main stuff
		cd "${S}/${f}"
		# hotplugdir is for usx2yloader/Makefile.am
		emake DESTDIR="${D}" hotplugdir=/lib/firmware install

		# Install the text documentation
		local doc
		for doc in README TODO ChangeLog AUTHORS; do
			if [[ -f "${doc}" ]]; then
				mv "${doc}" "${doc}.$(basename ${f})" || die
				dodoc "${doc}.$(basename ${f})"
			fi
		done
	done

	# Punt at least /usr/lib/liblo10k1.la (last checked, 1.0.27)
	prune_libtool_files
}
