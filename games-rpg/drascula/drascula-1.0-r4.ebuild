# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit desktop wrapper

INT_PV="1.1"
INT_URI="mirror://sourceforge/scummvm/drascula-int-${INT_PV}.zip"
DAT_PV="2.2.0"
AUD_PV="2.0"

DESCRIPTION="Drascula: The Vampire Strikes Back"
HOMEPAGE="http://www.alcachofasoft.com/"
SRC_URI="mirror://sourceforge/scummvm/drascula-${PV}.zip
	https://github.com/scummvm/scummvm/raw/v${DAT_PV}/dists/engine-data/drascula.dat -> drascula-${DAT_PV}.dat
	sound? ( mirror://sourceforge/scummvm/drascula-audio-${AUD_PV}.zip )
	https://salsa.debian.org/games-team/drascula/raw/master/debian/icons/drascula.png
	l10n_es? ( ${INT_URI} )
	l10n_de? ( ${INT_URI} )
	l10n_fr? ( ${INT_URI} )
	l10n_it? ( ${INT_URI} )"
S="${WORKDIR}"

LICENSE="drascula"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="l10n_es l10n_de l10n_fr l10n_it +sound"
RESTRICT="mirror"

RDEPEND="games-engines/scummvm[vorbis]"
BDEPEND="app-arch/unzip"

src_unpack() {
	if use l10n_es || use l10n_de || use l10n_fr || use l10n_it; then
		unpack drascula-int-${INT_PV}.zip
	fi
	if use sound; then
		unpack drascula-audio-${AUD_PV}.zip
	fi
	unpack drascula-${PV}.zip
}

src_install() {
	insinto /usr/share/${PN}
	newins "${DISTDIR}"/drascula-${DAT_PV}.dat drascula.dat
	doins Packet.001

	if use l10n_es || use l10n_de || use l10n_fr || use l10n_it; then
		doins ${PN}-int-${INT_PV}/PACKET.00[2-5]

		local lang
		for lang in es de fr it; do
			if use l10n_${lang}; then
				make_wrapper ${PN}-${lang} "scummvm -q ${lang} -f -p \"${EPREFIX}/usr/share/${PN}\" drascula"
				make_desktop_entry ${PN}-${lang} "Drascula (${lang})"
			fi
		done
	fi

	doicon "${DISTDIR}"/${PN}.png
	make_wrapper ${PN} "scummvm -f -p \"${EPREFIX}/usr/share/${PN}\" drascula"
	make_desktop_entry ${PN} Drascula

	use sound && doins -r audio/.

	dodoc readme.txt drascula.doc
}
