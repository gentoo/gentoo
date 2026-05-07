# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{11..14} )
VERIFY_SIG_OPENPGP_KEY_PATH=/usr/share/openpgp-keys/alsa.asc
inherit autotools flag-o-matic libtool linux-info python-single-r1 verify-sig xdg

DESCRIPTION="Advanced Linux Sound Architecture tools"
HOMEPAGE="https://alsa-project.org/wiki/Main_Page"
SRC_URI="
	https://www.alsa-project.org/files/pub/tools/${P}.tar.bz2
	verify-sig? ( https://www.alsa-project.org/files/pub/tools/${P}.tar.bz2.sig )
"

LICENSE="GPL-2"
SLOT="0.9"
KEYWORDS="~alpha ~amd64 ~arm64 ~hppa ~ppc ~ppc64 ~riscv ~sparc ~x86"

IUSE="fltk gtk alsa_cards_hdsp alsa_cards_hdspm alsa_cards_mixart
alsa_cards_vx222 alsa_cards_usb-usx2y alsa_cards_sb16 alsa_cards_sbawe
alsa_cards_emu10k1 alsa_cards_emu10k1x alsa_cards_ice1712
alsa_cards_rme32 alsa_cards_rme96 alsa_cards_sscape alsa_cards_pcxhr"

REQUIRED_USE="gtk? ( ${PYTHON_REQUIRED_USE} )"

# echomixer: gtk2
# envy24control: gtk4
# hdajackretask: gtk3
# hdajacksensetest: glib2
# hdspconf: fltk1
# hdspmixer: fltk1
# hwmixvolume: glib:2[introspection] gtk3[introspection] pyalsa pygobject
# rmedigicontrol: gtk2

# bug #468294
DEPEND="
	>=media-libs/alsa-lib-${PV}
	alsa_cards_ice1712? (
		gui-libs/gtk:4
	)
	fltk? ( x11-libs/fltk:1= )
	gtk? (
		dev-libs/glib:2[introspection]
		x11-libs/gtk+:2
		x11-libs/gtk+:3[introspection]
		$(python_gen_cond_dep '
			>=dev-python/pyalsa-1.0.26[${PYTHON_USEDEP}]
			dev-python/pygobject[${PYTHON_USEDEP}]
		')
	)
"
# bug #456114
RDEPEND="
	${DEPEND}
	gtk? (
		${PYTHON_DEPS}
		media-fonts/font-misc-misc
	)
"
BDEPEND="
	virtual/pkgconfig
	verify-sig? ( sec-keys/openpgp-keys-alsa )
"

PATCHES=(
	"${FILESDIR}"/envy24control-config-dir.patch
)

CONFIG_CHECK="~SND_HDA_RECONFIG"

pkg_setup() {
	linux-info_pkg_setup

	ALSA_TOOLS=(
		seq/sbiload
		us428control
		hda-verb
		$(usev alsa_cards_mixart mixartloader)
		$(usev alsa_cards_vx222 vxloader)
		$(usev alsa_cards_usb-usx2y usx2yloader)
		$(usev alsa_cards_pcxhr pcxhrloader)
		$(usev alsa_cards_sscape sscape_ctl)
	)

	if use gtk; then
		ALSA_TOOLS+=(
			echomixer
			hdajackretask
			hdajacksensetest
			hwmixvolume
		)
		# Perhaps a typo the following && logic?
		if use alsa_cards_rme32 && use alsa_cards_rme96 ; then
			ALSA_TOOLS+=( rmedigicontrol )
		fi

		# hwmixvolume
		python-single-r1_pkg_setup
	fi

	if use alsa_cards_ice1712; then
		ALSA_TOOLS+=(
			envy24control
		)
	fi

	if use alsa_cards_hdsp || use alsa_cards_hdspm ; then
		ALSA_TOOLS+=(
			hdsploader
			$(usev fltk 'hdspconf hdspmixer')
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
		pushd "${dir}" &> /dev/null || die
		eautoreconf
		popd &> /dev/null || die
	done

	# This block deals with the tools that are being patched
	for dir in hdspconf; do
		has "${dir}" "${ALSA_TOOLS[*]}" || continue
		pushd "${dir}" &> /dev/null || die
		eautoreconf
		popd &> /dev/null || die
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
			echomixer,rmedigicontrol )
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
		emake -C "${S}/${f}"
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

	if use gtk; then
		python_fix_shebang "${ED}/usr/bin/hwmixvolume"
	fi

	# Punt at least /usr/lib/liblo10k1.la (last checked, 1.0.27)
	find "${ED}" -type f -name '*.la' -delete || die
}
