# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit desktop wrapper

DESCRIPTION="Classic adventure game"
HOMEPAGE="https://wiki.scummvm.org/index.php/Soltys"
SRC_URI="l10n_en? ( mirror://sourceforge/scummvm/${PN}-en-v${PV}.zip )
	l10n_es? ( mirror://sourceforge/scummvm/${PN}-es-v${PV}.zip )
	l10n_pl? ( mirror://sourceforge/scummvm/${PN}-pl-v${PV}.zip )
	!l10n_en? ( !l10n_es? ( !l10n_pl? ( mirror://sourceforge/scummvm/${PN}-en-v${PV}.zip ) ) )
	http://www.scummvm.org/images/cat-${PN}.png"
S="${WORKDIR}"

LICENSE="Soltys"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="l10n_en l10n_es l10n_pl"

RDEPEND="games-engines/scummvm"
BDEPEND="app-arch/unzip"

src_unpack() {
	MY_L10N=( $(usev l10n_en) $(usev l10n_es) $(usev l10n_pl) )
	[[ ${MY_L10N} ]] || MY_L10N=( l10n_en )

	local lang
	for lang in "${MY_L10N[@]//l10n_/}"; do
		mkdir ${lang} || die
		unpack ${PN}-${lang}-v${PV}.zip
		if [[ ${lang} == es ]]; then
			mv ${PN}-${lang}-v$(ver_rs 1 -)/vol.{cat,dat} ${lang}/ || die
		else
			mv vol.{cat,dat} ${lang}/ || die
		fi
	done
}

src_install() {
	insinto /usr/share/${PN}
	local lang
	for lang in "${MY_L10N[@]//l10n_/}"; do
		doins -r ${lang}
		make_wrapper ${PN}-${lang} "scummvm -f -p \"${EPREFIX}/usr/share/${PN}/${lang}\" ${PN}"
		make_desktop_entry ${PN}-${lang} "Soltys (${lang})"
	done

	newicon "${DISTDIR}"/cat-${PN}.png ${PN}.png
}
