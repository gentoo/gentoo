# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit desktop wrapper

DESCRIPTION="Top-down adventure game set in a gritty futuristic/dystopian city"
HOMEPAGE="https://wiki.scummvm.org/index.php/Dreamweb"
SRC_URI="doc? ( mirror://sourceforge/scummvm/${PN}-manuals-en-highres.zip )
	l10n_de? ( mirror://sourceforge/scummvm/${PN}-cd-de-${PV}.zip )
	l10n_en? ( mirror://sourceforge/scummvm/${PN}-cd-us-${PV}.zip )
	l10n_en-GB? ( mirror://sourceforge/scummvm/${PN}-cd-uk-${PV}.zip )
	l10n_es? ( mirror://sourceforge/scummvm/${PN}-cd-es-${PV}.zip )
	l10n_fr? ( mirror://sourceforge/scummvm/${PN}-cd-fr-${PV}.zip )
	l10n_it? ( mirror://sourceforge/scummvm/${PN}-cd-it-${PV}.zip )
	!l10n_de? ( !l10n_en? ( !l10n_en-GB? ( !l10n_es? ( !l10n_fr? ( !l10n_it? \
		( mirror://sourceforge/scummvm/${PN}-cd-us-${PV}.zip ) ) ) ) ) )
	http://www.scummvm.org/images/cat-dreamweb.png"
S="${WORKDIR}"

LICENSE="Dreamweb"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc l10n_de +l10n_en l10n_en-GB l10n_es l10n_fr l10n_it"

RDEPEND="games-engines/scummvm[flac]"
BDEPEND="app-arch/unzip"

src_unpack() {
	MY_L10N=( $(usev l10n_de) $(usev l10n_es) $(usev l10n_fr) $(usev l10n_it) )
	MY_L10N+=( $(usev l10n_{en,us}) $(usev l10n_{en-GB,uk}) )
	[[ ${MY_L10N} ]] || MY_L10N=( l10n_us )

	local lang
	for lang in "${MY_L10N[@]//l10n_/}"; do
		mkdir "${S}"/${lang} || die
		cd "${S}"/${lang} || die
		unpack ${PN}-cd-${lang}-${PV}.zip
	done

	if use doc; then
		mkdir "${S}"/doc || die
		cd "${S}"/doc || die
		unpack ${PN}-manuals-en-highres.zip
	fi
}

src_prepare() {
	default
	rm -f */license.txt */*.EXE || die
}

src_install() {
	insinto /usr/share/${PN}
	local lang
	for lang in "${MY_L10N[@]//l10n_/}"; do
		doins -r ${lang}
		make_wrapper ${PN}-${lang} "scummvm -f -p \"${EPREFIX}/usr/share/${PN}/${lang}\" ${PN}"
		make_desktop_entry ${PN}-${lang} "Dreamweb (${lang})"
	done

	newicon "${DISTDIR}"/cat-${PN}.png ${PN}.png
	use doc && dodoc -r doc/.
}
