# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-mathematics/spass/spass-3.7.ebuild,v 1.5 2012/12/05 10:35:35 gienah Exp $

EAPI=5

inherit versionator

MY_PV=$(delete_all_version_separators "${PV}")
MY_P="${PN}${MY_PV}"

DESCRIPTION="An Automated Theorem Prover for First-Order Logic with Equality"
HOMEPAGE="http://www.spass-prover.org/"
SRC_URI="http://www.spass-prover.org/download/sources/${MY_P}.tgz"

LICENSE="BSD-2"
SLOT="0/${PV}"
KEYWORDS="~amd64 ~x86"
IUSE="doc examples isabelle"

RDEPEND="isabelle? (
			>=sci-mathematics/isabelle-2011.1-r1:=
		)"
DEPEND="${RDEPEND}"

S="${WORKDIR}/SPASS-${PV}"

src_prepare() {
	sed \
		-e "s:-O3:${CFLAGS}:g" \
		-i configure || die
}

src_install() {
	default

	if use examples; then
		insinto /usr/share/${PN}/
		doins -r examples
	fi

	if use isabelle; then
		ISABELLE_HOME="$(isabelle getenv ISABELLE_HOME | cut -d'=' -f 2)"
		[[ -n "${ISABELLE_HOME}" ]] || die "ISABELLE_HOME empty"
		dodir "${ISABELLE_HOME}/contrib/${PN}-${PV}/etc"
		cat <<- EOF >> "${S}/settings"
			SPASS_HOME="${ROOT}usr/bin"
			SPASS_VERSION="${PV}"
		EOF
		insinto "${ISABELLE_HOME}/contrib/${PN}-${PV}/etc"
		doins "${S}/settings"
	fi
}

pkg_postinst() {
	if use isabelle; then
		if [ -f "${ROOT}etc/isabelle/components" ]; then
			if egrep "contrib/${PN}-[0-9.]*" "${ROOT}etc/isabelle/components"; then
				sed -e "/contrib\/${PN}-[0-9.]*/d" \
					-i "${ROOT}etc/isabelle/components"
			fi
			cat <<- EOF >> "${ROOT}etc/isabelle/components"
				contrib/${PN}-${PV}
			EOF
		fi
	fi
}

pkg_postrm() {
	if use isabelle; then
		if [ ! -f "${ROOT}usr/bin/SPASS" ]; then
			if [ -f "${ROOT}etc/isabelle/components" ]; then
				# Note: this sed should only match the version of this ebuild
				# Which is what we want as we do not want to remove the line
				# of a new spass being installed during an upgrade.
				sed -e "/contrib\/${PN}-${PV}/d" \
					-i "${ROOT}etc/isabelle/components"
			fi
		fi
	fi
}
