# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Printer descriptions (PPDs) and filters for Kyocera 1x2x MFP"
HOMEPAGE="http://www.kyoceradocumentsolutions.eu"
SRC_URI="LinuxDrv_${PV}_FS-1x2xMFP.zip"

LICENSE="GPL-2 kyocera-mita-ppds"
SLOT="0"
KEYWORDS="-* ~amd64"

IUSE_L10N=( en ar cs de el es fr he hu it ko pl pt ro ru th tr vi zh-CN zh-TW )
IUSE="+rastertokpsl-fix +${IUSE_L10N[@]/#/l10n_}"
REQUIRED_USE="|| ( ${IUSE_L10N[@]/#/l10n_} )"
RESTRICT="fetch mirror"

RDEPEND="net-print/cups"
BDEPEND="app-arch/unzip"

QA_PREBUILT="/usr/libexec/cups/filter/rastertokpsl"

get_tarball_name() {
	# Note the capitalization inconsistency. Don't "fix" that.
	declare -A animals=(
		[ar]=arabic [cs]=czech [de]=German [el]=greek [en]=English
		[es]=Spanish [fr]=French [he]=hebrew [hu]=hungarian [it]=Italian
		[ko]=Korean [pl]=polish [pt]=Portuguese [ro]=romanian [ru]=russian
		[th]=thai [tr]=turkish [vi]=vietnamese [zh-CN]=simplified [zh-TW]=traditional
	)
	echo "${animals[$1]}"
}

pkg_nofetch() {
	einfo "Please, navigate your browser to the following URL, select"
	einfo "'Support - Downloads' in the menu, select 'FS-1025MFP',"
	einfo "select 'Linux print driver (${PV})', accept EULA, and manually"
	einfo "download the file named '${A}', then put it into your DISTDIR."
	einfo "https://www.kyoceradocumentsolutions.eu/en/support/downloads.name-L2V1L2VuL21mcC9GUzExMjVNRlA=.html"
	einfo
	einfo "Consider keeping a local copy of the file since there're chances"
	einfo "the company is going to eventually stop hosting it for whatever"
	einfo "reason."
}

src_unpack() {
	unpack ${A}
	S="${WORKDIR}/Linux/$(usex amd64 64bit 32bit)/Global"

	cd "${S}" || die
	local l10n
	for l10n in ${L10N}; do
		local language="$(get_tarball_name "${l10n}")"
		unpack "./${language}.tar.gz"
	done
}

src_prepare() {
	eapply_user

	# Original PPD files need patching, since they expect their filter
	# program to reside under /usr/lib, but Gentoo uses /usr/libexec.

	local orig="/usr/lib/cups/filter/rastertokpsl"
	local repl="/usr/libexec/cups/filter/rastertokpsl"
	if use rastertokpsl-fix; then
		repl+="-fix.sh"
	fi

	sed -i "s|${orig}|${repl}|g" ./*/Kyocera*.ppd || die
}

src_install() {
	insinto /usr/share/cups/model/KyoceraMita

	install_with_l10n_suffix() {
		local l10n="$1"; shift
		local file
		for file; do
			local bn="${file}"
			bn="${bn##*/}"
			bn="${bn%.ppd}"
			newins "${file}" "${bn}_${l10n}.ppd"
		done
	}

	local l10n
	for l10n in ${L10N}; do
		local language="$(get_tarball_name "${l10n}")"
		install_with_l10n_suffix "${l10n}" "./${language}"/Kyocera*.ppd
	done

	exeinto /usr/libexec/cups/filter

	# Each unpacked tarball contains an exact copy of 'rastertokpsl',
	# just take any of them.
	local rasterfile="$(find -name rastertokpsl -print -quit)"
	[[ $? -eq 0 && -n "${rasterfile}" ]] || die
	doexe "${rasterfile}"

	if use rastertokpsl-fix; then
		doexe "${FILESDIR}/rastertokpsl-fix.sh"
	fi

	dodoc ../../Readme.htm

	elog "This packages installs Kyocera's 'Readme.htm' file (see package"
	elog "documentation directory) which lists several common problems and"
	elog "workarounds. You might want to have a look on it."
	elog "(Merging the package with 'rastertokpsl-fix' USE flag can save you"
	elog "from getting some of these problems.)"
	elog
	elog "Hint: try socket:// protocol when configuring network printing."
}
