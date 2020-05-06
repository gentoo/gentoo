# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools flag-o-matic xdg

DESCRIPTION="Advanced Linux Sound Architecture tools"
HOMEPAGE="https://alsa-project.org/"
SRC_URI="https://www.alsa-project.org/files/pub/tools/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0.9"
KEYWORDS="~alpha amd64 ~hppa ~ia64 ~mips ppc ppc64 sparc x86"

IUSE="fltk gtk alsa_cards_hdsp alsa_cards_hdspm alsa_cards_mixart
alsa_cards_vx222 alsa_cards_usb-usx2y alsa_cards_sb16 alsa_cards_sbawe
alsa_cards_emu10k1 alsa_cards_emu10k1x alsa_cards_ice1712
alsa_cards_rme32 alsa_cards_rme96 alsa_cards_sscape alsa_cards_pcxhr"

DEPEND=">=media-libs/alsa-lib-${PV}
	>=dev-python/pyalsa-1.0.26
	fltk? ( >=x11-libs/fltk-1.3.0:1 )
	gtk? (
		dev-libs/gobject-introspection
		x11-libs/gtk+:2
		x11-libs/gtk+:3
	)" #468294
RDEPEND="${DEPEND}
	gtk? ( media-fonts/font-misc-misc )" #456114
BDEPEND="
	virtual/pkgconfig
"

PATCHES=(
	"${FILESDIR}"/envy24control-config-dir.patch
)

pkg_setup() {
	ALSA_TOOLS=(
		seq/sbiload
		us428control
		hwmixvolume
		hda-verb
		$(usex alsa_cards_mixart mixartloader '')
		$(usex alsa_cards_vx222 vxloader '')
		$(usex alsa_cards_usb-usx2y usx2yloader '')
		$(usex alsa_cards_pcxhr pcxhrloader '')
		$(usex alsa_cards_sscape sscape_ctl '')
	)

	if use gtk; then
		ALSA_TOOLS+=(
			echomixer
			hdajackretask
			$(usex alsa_cards_ice1712 envy24control '')
		)
		# Perhaps a typo the following && logic?
		if use alsa_cards_rme32 && use alsa_cards_rme96 ; then
			ALSA_TOOLS+=( rmedigicontrol )
		fi
	fi

	if use alsa_cards_hdsp || use alsa_cards_hdspm ; then
		ALSA_TOOLS+=(
			hdsploader
			$(usex fltk 'hdspconf hdspmixer' '')
		)
	fi

	if use alsa_cards_sb16 || use alsa_cards_sbawe ; then
		ALSA_TOOLS+=( sb16_csp )
	fi

	if use alsa_cards_emu10k1 || use alsa_cards_emu10k1x; then
		ALSA_TOOLS+=( as10k1 ld10k1 )
	fi
}

src_prepare() {
	default

	# This block only deals with the tools that still use GTK and the
	# AM_PATH_GTK macro.
	for dir in echomixer envy24control rmedigicontrol; do
		has "${dir}" "${ALSA_TOOLS[*]}" || continue
		pushd "${dir}" &> /dev/null
		eautoreconf
		popd &> /dev/null
	done

	# This block deals with the tools that are being patched
	for dir in hdspconf; do
		has "${dir}" "${ALSA_TOOLS[*]}" || continue
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
	for f in ${ALSA_TOOLS[@]} ; do
		cd "${S}/${f}" || die
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
	for f in ${ALSA_TOOLS[@]} ; do
		cd "${S}/${f}" || die
		emake
	done
}

src_install() {
	local f
	for f in ${ALSA_TOOLS[@]} ; do
		# Install the main stuff
		cd "${S}/${f}" || die
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
	find "${ED}" -type f -name '*.la' -delete || die
}
