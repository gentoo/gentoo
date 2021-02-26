# Copyright 2019-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit vdr-plugin-2

MY_P="vdr-plugin-dvbapi-${PV}"

DESCRIPTION="VDR Plugin: allows connect VDR to OScam"
HOMEPAGE="https://github.com/manio/vdr-plugin-dvbapi"
SRC_URI="https://github.com/manio/vdr-plugin-dvbapi/archive/v${PV}.tar.gz -> ${MY_P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="cpu_flags_x86_3dnow cpu_flags_x86_mmx cpu_flags_x86_sse cpu_flags_x86_sse2 dvbcsa"

DEPEND=">=media-video/vdr-2.4.1
	dvbcsa? ( media-libs/libdvbcsa )"
RDEPEND="${DEPEND}"

DOCS=( "FAQ" "HISTORY" "INSTALL" "README" "FFdecsa/docs" )
QA_FLAGS_IGNORED="
	usr/lib/vdr/plugins/libvdr-dvbapi.*
	usr/lib64/vdr/plugins/libvdr-dvbapi.*"
S="${WORKDIR}/${MY_P}"

src_prepare() {
	vdr-plugin-2_src_prepare

	# respect the system CXXFLAGS
	sed -e "s:FLAGS:CXXFLAGS:" -i FFdecsa/Makefile || die "modifying FFdecsa/Makefile"

	if use dvbcsa; then
		sed -e "s:PLUGIN = dvbapi:PLUGIN = dvbapi\nLIBDVBCSA = 1:" -i Makefile || die "modifying Makefile"
	else
		# Prepare flags for FFdeCSA
		if [[ -n "${VDR_DVBAPI_PARALLEL}" ]]; then
			PARALLEL="${VDR_DVBAPI_PARALLEL}"
		else
			# [32/64] Core2 (SSSE3) achieves best results with SSE2 & SSE
			# [64] Athlon64 (SSE2) does much better with 64_LONG
			# [32] Athlon64 (SSE2) does best with MMX
			# [32] Pentium4 & Atom (SSE2) work best with SSE2 & SSE
			# [32] AthlonXP (SSE) has MMX faster

			# To avoid parsing -march=, we use ugly assumption that Intels don't
			# have 3dnow and AMDs do. SSE achieves good results only on Intel CPUs,
			# and LONG is best on 64-bit AMD CPUs.

			if ! use cpu_flags_x86_3dnow && use cpu_flags_x86_sse2; then
				PARALLEL=PARALLEL_128_SSE2
			elif ! use cpu_flags_x86_3dnow && use cpu_flags_x86_sse; then
				PARALLEL=PARALLEL_128_SSE
			elif use amd64; then
				PARALLEL=PARALLEL_64_LONG
			elif use cpu_flags_x86_mmx; then
				PARALLEL=PARALLEL_64_MMX
			else
				# fallback values:
				# PARALLEL_32_INT fails with gcc4.4 on x86&amd64
				# PARALLEL_64_2INT fails with gcc4.4 on x86
				# PARALLEL_128_4INT seems to be the fastest non-failing fallback
				PARALLEL=PARALLEL_128_4INT
			fi

			ewarn "VDR_DVBAPI_PARALLEL in your system make.conf is not set, guessing"
			ewarn "value from CPU_FLAGS_X86 USEflags, result: ${PARALLEL}"
			ewarn "This setting may be suboptimal, so you'll probably want to tweak"
			ewarn "it yourself."
			ewarn
			ewarn "To do this, unpack the source and run the script in"
			ewarn "\t<unpackdir>/${MY_P}/extra/FFdecsa-benchmark.sh"
			ewarn "and add the output value from  PARALLEL_MODE= to your system make.conf as"
			ewarn "\tVDR_DVBAPI_PARALLEL=<your parameter>"
			ewarn
		fi
		export PARALLEL
	fi
}

pkg_postinst() {
	vdr-plugin-2_pkg_postinst

	elog "This software might be illegal in some countries or violate"
	elog "rules of your DVB provideri. Please respect these rules."
	elog
	elog "We do not offer support of any kind."
	elog "Asking for keys or for installation help will be ignored by gentoo developers!"
	elog
}
