# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit autotools multilib-minimal

DESCRIPTION="Flite text to speech engine"
HOMEPAGE="http://www.festvox.org/flite/ https://github.com/festvox/flite"
SRC_URI="https://github.com/festvox/flite/archive/v${PV}.tar.gz -> ${P}.tar.gz
	voices? (
		http://www.festvox.org/${PN}/packed/${P}/voices/cmu_indic_ben_rm.flitevox
		http://www.festvox.org/${PN}/packed/${P}/voices/cmu_indic_guj_ad.flitevox
		http://www.festvox.org/${PN}/packed/${P}/voices/cmu_indic_guj_dp.flitevox
		http://www.festvox.org/${PN}/packed/${P}/voices/cmu_indic_guj_kt.flitevox
		http://www.festvox.org/${PN}/packed/${P}/voices/cmu_indic_hin_ab.flitevox
		http://www.festvox.org/${PN}/packed/${P}/voices/cmu_indic_kan_plv.flitevox
		http://www.festvox.org/${PN}/packed/${P}/voices/cmu_indic_mar_aup.flitevox
		http://www.festvox.org/${PN}/packed/${P}/voices/cmu_indic_mar_slp.flitevox
		http://www.festvox.org/${PN}/packed/${P}/voices/cmu_indic_pan_amp.flitevox
		http://www.festvox.org/${PN}/packed/${P}/voices/cmu_indic_tam_sdr.flitevox
		http://www.festvox.org/${PN}/packed/${P}/voices/cmu_indic_tel_kpn.flitevox
		http://www.festvox.org/${PN}/packed/${P}/voices/cmu_indic_tel_sk.flitevox
		http://www.festvox.org/${PN}/packed/${P}/voices/cmu_indic_tel_ss.flitevox
		http://www.festvox.org/${PN}/packed/${P}/voices/cmu_us_aew.flitevox
		http://www.festvox.org/${PN}/packed/${P}/voices/cmu_us_ahw.flitevox
		http://www.festvox.org/${PN}/packed/${P}/voices/cmu_us_aup.flitevox
		http://www.festvox.org/${PN}/packed/${P}/voices/cmu_us_awb.flitevox
		http://www.festvox.org/${PN}/packed/${P}/voices/cmu_us_axb.flitevox
		http://www.festvox.org/${PN}/packed/${P}/voices/cmu_us_bdl.flitevox
		http://www.festvox.org/${PN}/packed/${P}/voices/cmu_us_clb.flitevox
		http://www.festvox.org/${PN}/packed/${P}/voices/cmu_us_eey.flitevox
		http://www.festvox.org/${PN}/packed/${P}/voices/cmu_us_fem.flitevox
		http://www.festvox.org/${PN}/packed/${P}/voices/cmu_us_gka.flitevox
		http://www.festvox.org/${PN}/packed/${P}/voices/cmu_us_jmk.flitevox
		http://www.festvox.org/${PN}/packed/${P}/voices/cmu_us_ksp.flitevox
		http://www.festvox.org/${PN}/packed/${P}/voices/cmu_us_ljm.flitevox
		http://www.festvox.org/${PN}/packed/${P}/voices/cmu_us_lnh.flitevox
		http://www.festvox.org/${PN}/packed/${P}/voices/cmu_us_rms.flitevox
		http://www.festvox.org/${PN}/packed/${P}/voices/cmu_us_rxr.flitevox
		http://www.festvox.org/${PN}/packed/${P}/voices/cmu_us_slp.flitevox
		http://www.festvox.org/${PN}/packed/${P}/voices/cmu_us_slt.flitevox
	)"

LICENSE="BSD freetts public-domain regexp-UofT BSD-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~ia64 ~ppc ~ppc64 ~sparc ~x86"
IUSE="alsa oss pulseaudio voices"

DEPEND="
	pulseaudio? ( media-sound/pulseaudio[${MULTILIB_USEDEP}] )
	!pulseaudio? ( alsa? ( >=media-libs/alsa-lib-1.0.27.2[${MULTILIB_USEDEP}] ) )
"
RDEPEND="${DEPEND}"

PATCHES=(
	"${FILESDIR}"/${PN}-1.4-audio-interface.patch
)

get_audio() {
	if use pulseaudio; then
		echo pulseaudio
	elif use alsa; then
		echo alsa
	elif use oss; then
		echo oss
	else
		echo none
	fi
}

src_unpack() {
	for file in ${A}; do
		case "${file}" in
			*.flitevox)
				cp -av "${DISTDIR}/${file}" "${WORKDIR}/" || die "Unable to copy ${file}"
				;;
			*)
				unpack "${file}"
				;;
		esac
	done
}

src_prepare() {
	default
	sed -i main/Makefile \
		-e '/-rpath/s|$(LIBDIR)|$(INSTALLLIBDIR)|g' \
		|| die
	mv configure.{in,ac} || die
	eautoreconf

	# custom makefiles
	multilib_copy_sources
}

multilib_src_configure() {
	local myconf=(
		--enable-shared
		--with-audio=$(get_audio)
	)
	econf "${myconf[@]}"
}

multilib_src_compile() {
	emake CC="$(tc-getCC)" CFLAGS="${CFLAGS}"
}

multilib_src_install_all() {
	dodoc ACKNOWLEDGEMENTS README.md

	rm -rf "${D}"/usr/lib*/*.a

	if use voices; then
		insinto /usr/share/flite
		doins "${WORKDIR}"/*.flitevox
	fi
}

pkg_postinst() {
	if [[ "$(get_audio)" = "none" ]]; then
		ewarn "flite is built without audio support. Enable the"
		ewarn "alsa, oss, or pulseaudio USE flags for audio support."
	fi
}
