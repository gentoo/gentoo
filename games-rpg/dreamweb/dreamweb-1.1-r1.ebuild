# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit eutils

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

LICENSE="Dreamweb"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc l10n_de l10n_en l10n_en-GB l10n_es l10n_fr l10n_it"

RDEPEND=">=games-engines/scummvm-1.7[flac]"
DEPEND="app-arch/unzip"

S="${WORKDIR}"

src_unpack() {
	if use l10n_de ; then
		mkdir -p "${S}"/de || die
		cd "${S}"/de || die
		unpack ${PN}-cd-de-${PV}.zip
	fi
	if use l10n_en || ( ! use l10n_de && ! use l10n_en && ! use l10n_en-GB && \
			! use l10n_es && ! use l10n_fr && ! use l10n_it ) ; then
		mkdir -p "${S}"/en_US || die
		cd "${S}"/en_US || die
		unpack ${PN}-cd-us-${PV}.zip
	fi
	if use l10n_en-GB ; then
		mkdir -p "${S}"/en_GB || die
		cd "${S}"/en_GB || die
		unpack ${PN}-cd-uk-${PV}.zip
	fi
	if use l10n_es ; then
		mkdir -p "${S}"/es || die
		cd "${S}"/es || die
		unpack ${PN}-cd-es-${PV}.zip
	fi
	if use l10n_fr ; then
		mkdir -p "${S}"/fr || die
		cd "${S}"/fr || die
		unpack ${PN}-cd-fr-${PV}.zip
	fi
	if use l10n_it ; then
		mkdir -p "${S}"/it || die
		cd "${S}"/it || die
		unpack ${PN}-cd-it-${PV}.zip
	fi
	if use doc ; then
		mkdir -p "${S}"/doc || die
		cd "${S}"/doc || die
		unpack ${PN}-manuals-en-highres.zip
	fi
}

src_prepare() {
	default
	rm -rf */license.txt */*.EXE || die
}

src_install() {
	insinto /usr/share/${PN}
	newicon "${DISTDIR}"/cat-dreamweb.png dreamweb.png
	if use l10n_de ; then
		doins -r de
		make_wrapper dreamweb-de "scummvm -f -p \"/usr/share/${PN}/de\" dreamweb" .
		make_desktop_entry ${PN}-de "Dreamweb (Deutsch)" dreamweb
	fi
	if use l10n_en || ( ! use l10n_de && ! use l10n_en && ! use l10n_en-GB && \
			! use l10n_es && ! use l10n_fr && ! use l10n_it ) ; then
		doins -r en_US
		make_wrapper dreamweb-en_US "scummvm -f -p \"/usr/share/${PN}/en_US\" dreamweb" .
		make_desktop_entry ${PN}-en_US "Dreamweb (US English)" dreamweb
	fi
	if use l10n_en-GB ; then
		doins -r en_GB
		make_wrapper dreamweb-en_GB "scummvm -f -p \"/usr/share/${PN}/en_GB\" dreamweb" .
		make_desktop_entry ${PN}-en_GB "Dreamweb (UK English)" dreamweb
	fi
	if use l10n_es ; then
		doins -r es
		make_wrapper dreamweb-es "scummvm -f -p \"/usr/share/${PN}/es\" dreamweb" .
		make_desktop_entry ${PN}-es "Dreamweb (Español)" dreamweb
	fi
	if use l10n_fr ; then
		doins -r fr
		make_wrapper dreamweb-fr "scummvm -f -p \"/usr/share/${PN}/fr\" dreamweb" .
		make_desktop_entry ${PN}-fr "Dreamweb (Français)" dreamweb
	fi
	if use l10n_it ; then
		doins -r it
		make_wrapper dreamweb-it "scummvm -f -p \"/usr/share/${PN}/it\" dreamweb" .
		make_desktop_entry ${PN}-it "Dreamweb (Italiano)" dreamweb
	fi
	use doc && dodoc -r doc/*
}
