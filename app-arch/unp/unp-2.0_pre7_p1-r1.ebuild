# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit bash-completion-r1

DESCRIPTION="Script for unpacking various file formats"
HOMEPAGE="https://packages.qa.debian.org/u/unp.html"
TEMP_PV="${PV/_pre/$'\x7e'pre}"
MY_PV="${TEMP_PV/_p/+nmu}"
SRC_URI="mirror://debian/pool/main/u/unp/${PN}_${MY_PV}.tar.bz2"
S="${WORKDIR}/${PN}-${MY_PV}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~arm ~hppa ~ppc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos ~sparc-solaris ~x86-solaris"
IUSE="l10n_cs l10n_de l10n_fr l10n_it l10n_pt nls"

DEPEND="nls? ( sys-devel/gettext )"

RDEPEND="${DEPEND}
	dev-lang/perl"

PATCHES=( "${FILESDIR}"/${PN}-2.0-remove-deprecated-have.patch )

src_compile() {
	if use nls; then
		mofiles=()
		use l10n_cs && mofiles+=( 'cs.po' )
		use l10n_de && mofiles+=( 'de.po' )
		use l10n_fr && mofiles+=( 'fr.po' )
		use l10n_it && mofiles+=( 'it.po' )
		use l10n_pt && mofiles+=( 'pt.po' )
		if [[ ${#mofiles[@]} == 0 ]]; then
			emake -C po
		else
			emake -C po MOFILES="${mofiles[*]}"
		fi
	fi
}

src_install() {
	dobin unp || die "dobin failed"
	dosym unp /usr/bin/ucat
	doman debian/unp.1 || die "doman failed"
	dodoc debian/changelog debian/README.Debian
	dobashcomp bash_completion.d/unp

	if use nls; then
		mofiles=()
		use l10n_cs && mofiles+=( 'cs.mo' )
		use l10n_de && mofiles+=( 'de.mo' )
		use l10n_fr && mofiles+=( 'fr.mo' )
		use l10n_it && mofiles+=( 'it.mo' )
		use l10n_pt && mofiles+=( 'pt.mo' )
		if [[ ${#mofiles[@]} == 0 ]]; then
			emake -C po DESTDIR="${ED}" install
		else
			emake -C po MOFILES="${mofiles[*]}" DESTDIR="${ED}" install
		fi
	fi
}
