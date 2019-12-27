# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python3_{6,7,8} )

inherit desktop python-single-r1

DESCRIPTION="An enriched clone of the game 'Logical' by Rainbow Arts"
HOMEPAGE="http://pathological.sourceforge.net/"
SRC_URI="
	mirror://sourceforge/${PN}/${P/_p*}.tar.gz
	mirror://debian/pool/main/${PN:0:1}/${PN}/${PN}_${PV/_p*}-${PV/*_p}.debian.tar.xz
"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

IUSE="doc"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="${PYTHON_DEPS}
	>=dev-python/pygame-1.5.5[${PYTHON_USEDEP}]
"
DEPEND="${RDEPEND}"
BDEPEND="${PYTHON_DEPS}
	doc? ( media-libs/netpbm )
"

S="${WORKDIR}/${P/_p*}"

src_unpack() {
	unpack ${A}
	cd "${S}" || die
	unpack ./${PN}.6.gz
}

src_prepare() {
	default

	# Debian fixes
	# We don't face this bug, this way we skip needing to convert the
	# files at build time
	sed -i -e '/60_use_ogg_music.patch/d' "${WORKDIR}"/debian/patches/series || die

	for p in $(<"${WORKDIR}"/debian/patches/series) ; do
		eapply -p1 "${WORKDIR}/debian/patches/${p}"
	done

	# Fix prestripped files
	eapply "${FILESDIR}/${PN}-1.1.3-build-r1.patch"

	if use doc ; then
		sed -i -e '5,$ s/=/ /g' makehtml || die
	else
		echo "#!/bin/sh" > makehtml
	fi

	sed -i \
		-e "s:/usr/share/games:/usr/share:" \
		-e "s:exec:exec ${EPYTHON}:" \
		${PN} || die

	sed -i \
		-e 's:\xa9:(C):' \
		-e "s:/usr/lib/${PN}/bin:/usr/$(get_libdir)/${PN}:" \
		${PN}.py || die

	python_fix_shebang ${PN}.py
}

src_install() {
	dobin ${PN}

	exeinto /usr/"$(get_libdir)"/${PN}
	doexe write-highscores

	insinto /usr/share/${PN}
	doins -r circuits graphics music sounds ${PN}.py

	insinto /var/games/
	doins ${PN}_scores
	fperms 660 /var/games/${PN}_scores

	doman ${PN}.6
	use doc && local HTML_DOCS=( html/. )
	einstalldocs
	dodoc changelog

	doicon ${PN}.xpm
	make_desktop_entry ${PN} Pathological ${PN}

	# remove some unneeded resource files
	rm -f "${ED}"/usr/share/${PN}/graphics/*.xcf
}

pkg_postinst() {
	if ! has_version "media-libs/sdl-mixer[mod]" ; then
		echo
		elog "Since you have turned off the 'mod' use flag for media-libs/sdl-mixer"
		elog "no background music will be played."
		echo
	fi

}
