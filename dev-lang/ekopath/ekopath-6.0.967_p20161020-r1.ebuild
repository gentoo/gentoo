# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit pax-utils versionator

MY_PV=$(get_version_component_range 1-3)
MY_P=${PN}-${MY_PV}
DATE=$(get_version_component_range 4)
DATE=${DATE#p}
DATE=${DATE:0:4}-${DATE:4:2}-${DATE:6}
INSTALLER=${PN}-${DATE}-installer.run

DESCRIPTION="PathScale EKOPath Compiler Suite"
HOMEPAGE="http://www.pathscale.com/ekopath-compiler-suite"
SRC_URI="http://c591116.r16.cf2.rackcdn.com/${PN}/nightly/Linux/${INSTALLER}"

LICENSE="all-rights-reserved"
SLOT="${MY_PV}"
KEYWORDS="~amd64"
IUSE="mpich openmpi openmpi2"

DEPEND="!!app-arch/rpm"
RDEPEND="!dev-lang/ekopath:0/${MY_PV}"

RESTRICT="bindist mirror"

QA_PREBUILT="opt/${MY_P}/*"

S="${WORKDIR}"

src_unpack() {
	cp "${DISTDIR}/${INSTALLER}" "${S}/" || die
	chmod +x "${S}/${INSTALLER}" || die
}

src_install() {
	# EI_PAX marking is obsolete and PT_PAX breaks the binary.
	# We must use XT_PAX to run the installer.
	if [[ ${PAX_MARKINGS} == "XT" ]]; then
		pax-mark m "${INSTALLER}"
	fi

	./"${INSTALLER}" \
		--prefix "${ED%/}/opt/${MY_P}" \
		--mode unattended || die

	if [[ ! -d ${ED%/}/opt/${MY_P}/lib/${MY_PV} ]]; then
		local guess
		cd "${ED%/}/opt/${MY_P}/lib" && guess=( * )

		if [[ ${guess[@]} ]]; then
			die "Incorrect release version in PV, guessing it should be: ${guess[*]}"
		else
			die "No libdir installed"
		fi
	fi
	[[ -x ${ED%}/opt/${MY_P}/bin/pathcc ]] || die "No pathcc executable was installed, your hardware is unsupported most likely"

	rm -r "${ED}/opt/${MY_P}"/uninstall* || die

	# cleanup
	if ! use mpich; then
		rm -r "${ED}/opt/${MY_P}/mpi/mpich" || die
	fi
	if ! use openmpi; then
		rm -r "${ED}/opt/${MY_P}/mpi"/openmpi-1.* || die
	fi
	if ! use openmpi2; then
		rm -r "${ED}/opt/${MY_P}/mpi"/openmpi-2.* || die
	fi
}
