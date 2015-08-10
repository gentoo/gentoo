# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-lang/ekopath/ekopath-6.0.468_p20150803.ebuild,v 1.1 2015/08/04 16:35:58 mgorny Exp $

EAPI=5

inherit versionator multilib pax-utils

MY_PV=$(get_version_component_range 1-3)
DATE=$(get_version_component_range 4)
DATE=${DATE#p}
DATE=${DATE:0:4}-${DATE:4:2}-${DATE:6}
INSTALLER=${PN}-${DATE}-installer.run

DESCRIPTION="PathScale EKOPath Compiler Suite"
HOMEPAGE="http://www.pathscale.com/ekopath-compiler-suite"
SRC_URI="http://c591116.r16.cf2.rackcdn.com/${PN}/nightly/Linux/${INSTALLER}"

LICENSE="all-rights-reserved"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND="!!app-arch/rpm"
RDEPEND=""

RESTRICT="bindist mirror"

QA_PREBUILT="
	opt/${PN}/lib/${MY_PV}/x8664/*
	opt/${PN}/bin/*"

S="${WORKDIR}"

src_unpack() {
	cp "${DISTDIR}/${INSTALLER}" "${S}/" || die
	chmod +x "${S}/${INSTALLER}" || die
}

src_prepare() {
	cat > 99${PN} <<-EOF
		PATH=${EROOT%/}/opt/${PN}/bin
		ROOTPATH=${EROOT%/}/opt/${PN}/bin
		LDPATH=${EROOT%/}/opt/${PN}/lib:${EROOT%/}/opt/${PN}/lib/${MY_PV}/x8664/64
		MANPATH=${EROOT%/}/opt/${PN}/docs/man
	EOF
}

src_install() {
	# EI_PAX marking is obsolete and PT_PAX breaks the binary.
	# We must use XT_PAX to run the installer.
	if [[ ${PAX_MARKINGS} == "XT" ]]; then
		pax-mark m "${INSTALLER}"
	fi

	./"${INSTALLER}" \
		--prefix "${ED%/}/opt/${PN}" \
		--mode unattended || die

	if [[ ! -d ${ED%/}/opt/${PN}/lib/${MY_PV} ]]; then
		local guess
		cd "${ED%/}/opt/${PN}/lib" && guess=( * )

		if [[ ${guess[@]} ]]; then
			die "Incorrect release version in PV, guessing it should be: ${guess[*]}"
		else
			die "No libdir installed"
		fi
	fi
	[[ -x ${ED%}/opt/${PN}/bin/pathcc ]] || die "No pathcc executable was installed, your hardware is unsupported most likely"

	rm -r "${ED}/opt/${PN}"/uninstall* || die
	doenvd 99${PN}
}
