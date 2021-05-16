# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CDROM_OPTIONAL="yes"
MY_PN_DEMO="3dduke"
MY_PN_GOG="gog_duke_nukem_3d_atomic_edition"
MY_PV_DEMO="13"
MY_PV_GOG="2.0.0.9"
MY_P_DEMO="${MY_PN_DEMO}${MY_PV_DEMO}"
MY_P_GOG="${MY_PN_GOG}_${MY_PV_GOG}"

inherit cdrom

DESCRIPTION="Duke Nukem 3D (Atomic Edition) data files"
HOMEPAGE="http://www.3drealms.com/"
SRC_URI="
	demo? ( "ftp://ftp.3drealms.com/share/${MY_P_DEMO}.zip" )
	gog? ( "${MY_P_GOG}.sh" )
"
S="${WORKDIR}"

LICENSE="DUKE3D gog? ( GOG-EULA )"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~x86"
IUSE="+demo gog"
REQUIRED_USE="^^ ( cdinstall demo gog )"
RESTRICT="bindist gog? ( fetch ) mirror"

BDEPEND="
	demo? ( app-arch/unzip )
	gog? ( app-arch/unzip )
"

pkg_nofetch() {
	if use gog; then
		einfo "Please download ${MY_P_GOG}.sh from your GOG.com account after"
		einfo "buying Duke Nukem 3D and place it into your DISTDIR directory."
	fi
}

src_unpack() {
	if use cdinstall ; then
		local CDROM_NAMES=(
			"Existing installation"
			"Duke Nukem 3D CD"
			"Duke Nukem 3D Atomic Edition CD"
		)

		cdrom_get_cds duke3d.grp:dn3dinst/duke3d.grp:atominst/duke3d.grp

		! [[ "${CDROM_SET}" -ge 0 && "${CDROM_SET}" -le 2 ]] && die "Could not locate data files."
	fi

	if use demo; then
		# Use '-LL' to extract everything in lowercase.
		unzip "${DISTDIR}/${MY_P_DEMO}.zip" || die
		unzip -LL "DN3DSW${MY_PV_DEMO}.SHR" || die
	fi

	if use gog; then
		# Since 'unpacker' eclass does not support options,
		# doing manual unpack and checking for return code,
		# as all non-fatal errors should be ignored, because
		# it's a self-extracting archive and will fail otherwise.
		# Also use '-LL' to extract everything in lowercase.
		unzip -LL "${DISTDIR}/${MY_P_GOG}.sh"
		[[ $? -le 1 ]] || die
	fi
}

src_install() {
	if use cdinstall; then
		local DATAROOT

		case ${CDROM_SET} in
			0) DATAROOT="" ;;
			1) DATAROOT="dn3dinst" ;;
			2) DATAROOT="atominst" ;;
		esac

		pushd "${CDROM_ROOT}/${DATAROOT}" || die
	fi

	if use gog; then
		pushd "${S}/data/noarch/data" || die
	fi

	insinto /usr/share/duke3d
	for file in *.con *.dmo *.grp *.rts; do
		newins "${file}" "${file,,}"
	done

	if ! use demo; then
		if use cdinstall && [[ "${CDROM_SET}" -ne 0 ]]; then
			doins ../goodies/build/*.map
		else
			doins *.map
		fi

		popd || die
	fi
}

pkg_postinst() {
	if use demo; then
		einfo "Please keep in mind, that many addons for Duke Nukem 3D will require"
		einfo "the registered version and will not work with the shareware version."
	fi
}
