# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit eutils

DESCRIPTION="Classic adventure game"
HOMEPAGE="https://wiki.scummvm.org/index.php/Soltys"
SRC_URI="l10n_en? ( mirror://sourceforge/scummvm/${PN}-en-v${PV}.zip )
	l10n_es? ( mirror://sourceforge/scummvm/${PN}-es-v${PV}.zip )
	l10n_pl? ( mirror://sourceforge/scummvm/${PN}-pl-v${PV}.zip )
	!l10n_en? ( !l10n_es? ( !l10n_pl? ( mirror://sourceforge/scummvm/${PN}-en-v${PV}.zip ) ) )
	http://www.scummvm.org/images/cat-soltys.png"

LICENSE="Soltys"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="l10n_en l10n_es l10n_pl"

RDEPEND=">=games-engines/scummvm-1.5"
DEPEND="app-arch/unzip"

S="${WORKDIR}"

src_unpack() {
	if use l10n_en || ( ! use l10n_en && ! use l10n_es && ! use l10n_pl ) ; then
		mkdir -p en || die
		unpack ${PN}-en-v${PV}.zip
		mv vol.{cat,dat} en/ || die
	fi
	if use l10n_es ; then
		mkdir -p es || die
		unpack ${PN}-es-v${PV}.zip
		mv soltys-es-v1-0/vol.{cat,dat} es/ || die
	fi
	if use l10n_pl ; then
		mkdir -p pl || die
		unpack ${PN}-pl-v${PV}.zip
		mv vol.{cat,dat} pl/ || die
	fi
}

src_prepare() {
	default
	rm -rf license.txt soltys-es-v1-0
}

src_install() {
	insinto /usr/share/${PN}
	doins -r *
	newicon "${DISTDIR}"/cat-soltys.png soltys.png
	if use l10n_en || ( ! use l10n_en && ! use l10n_es && ! use l10n_pl ) ; then
		make_wrapper soltys-en "scummvm -f -p \"/usr/share/${PN}/en\" soltys" .
		make_desktop_entry ${PN}-en "Soltys (English)" soltys
	fi
	if use l10n_es ; then
		make_wrapper soltys-es "scummvm -f -p \"/usr/share/${PN}/es\" soltys" .
		make_desktop_entry ${PN}-es "Soltys (Español)" soltys
	fi
	if use l10n_pl ; then
		make_wrapper soltys-pl "scummvm -f -p \"/usr/share/${PN}/pl\" soltys" .
		make_desktop_entry ${PN}-pl "Soltys (Polski)" soltys
	fi
}
