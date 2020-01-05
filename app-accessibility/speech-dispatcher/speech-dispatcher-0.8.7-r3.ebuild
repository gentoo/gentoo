# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6,7} )

inherit eutils python-r1

DESCRIPTION="Speech synthesis interface"
HOMEPAGE="http://www.freebsoft.org/speechd"
SRC_URI="http://www.freebsoft.org/pub/projects/speechd/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86 ~amd64-linux ~x86-linux"
IUSE="alsa ao +espeak flite nas pulseaudio python"

REQUIRED_USE="python? ( ${PYTHON_REQUIRED_USE} )"

COMMON_DEPEND="python? ( ${PYTHON_DEPS} )
	>=dev-libs/dotconf-1.3
	>=dev-libs/glib-2.28:2
	dev-libs/libltdl:0
	>=media-libs/libsndfile-1.0.2
	alsa? ( media-libs/alsa-lib )
	ao? ( media-libs/libao )
	espeak? ( app-accessibility/espeak )
	flite? ( app-accessibility/flite )
	nas? ( media-libs/nas )
	pulseaudio? ( media-sound/pulseaudio )"
DEPEND="${COMMON_DEPEND}
	>=dev-util/intltool-0.40.0
	virtual/pkgconfig"
RDEPEND="${COMMON_DEPEND}
	python? ( dev-python/pyxdg[${PYTHON_USEDEP}] )"

src_configure() {
	# bug 573732
	export GIT_CEILING_DIRECTORIES="${WORKDIR}"

	local myeconfargs=(
		--disable-python
		--disable-static
		$(use_with alsa)
		$(use_with ao libao)
		$(use_with espeak)
		$(use_with flite)
		$(use_with pulseaudio pulse)
		$(use_with nas)
	)
	econf ${myeconfargs[@]}
}

src_compile() {
	use python && python_copy_sources

	emake

	if use python; then
		building() {
			cd src/api/python || die
			emake \
				pyexecdir="$(python_get_sitedir)" \
				pythondir="$(python_get_sitedir)"
		}
		python_foreach_impl run_in_build_dir building
	fi
}

src_install() {
	emake DESTDIR="${D}" install
	dodoc ANNOUNCE AUTHORS BUGS FAQ NEWS README*

	if use python; then
		installation() {
			cd src/api/python || die
			emake \
				DESTDIR="${D}" \
				pyexecdir="$(python_get_sitedir)" \
				pythondir="$(python_get_sitedir)" \
				install
		}
		python_foreach_impl run_in_build_dir installation
		python_replicate_script "${ED}"/usr/bin/spd-conf
	fi

	find "${D}" -name '*.la' -delete || die
}

pkg_postinst() {
	local editconfig="n"
	if ! use espeak; then
		ewarn "You have disabled espeak, which is speech-dispatcher's"
		ewarn "default speech synthesizer."
		ewarn
		editconfig="y"
	fi
	if ! use pulseaudio; then
		ewarn "You have disabled pulseaudio support."
		ewarn "pulseaudio is speech-dispatcher's default audio subsystem."
		ewarn
		editconfig="y"
	fi
	if [[ "${editconfig}" == "y" ]]; then
		ewarn "You must edit ${EROOT}/etc/speech-dispatcher/speechd.conf"
		ewarn "and make sure the settings there match your system."
		ewarn
	fi
	elog "For festival support, you need to"
	elog "install app-accessibility/festival-freebsoft-utils."
}
