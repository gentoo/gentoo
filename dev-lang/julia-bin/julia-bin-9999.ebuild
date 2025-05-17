# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_PN=${PN/-bin/}

inherit edo

DESCRIPTION="High-performance programming language for technical computing"
HOMEPAGE="https://julialang.org/"

if [[ ${PV} == 9999 ]] ; then
	MY_P=${MY_PN}-latest
	S="${WORKDIR}/"

	SLOT="9999"
	BDEPEND="net-misc/wget"
	PROPERTIES="live"
else
	MY_P=${MY_PN}-${PV/_/-}
	MY_PV=$(ver_cut 1-2)
	BASE_SRC_URI="https://julialang-s3.julialang.org/bin"

	SRC_URI="
		x86? ( ${BASE_SRC_URI}/linux/x86/${MY_PV}/${MY_P}-linux-i686.tar.gz )
		amd64? (
			elibc_glibc? ( ${BASE_SRC_URI}/linux/x64/${MY_PV}/${MY_P}-linux-x86_64.tar.gz )
			elibc_musl? ( ${BASE_SRC_URI}/musl/x64/${MY_PV}/${MY_P}-musl-x86_64.tar.gz )
		)
		arm64? ( ${BASE_SRC_URI}/linux/aarch64/${MY_PV}/${MY_P}-linux-aarch64.tar.gz )
	"

	SLOT="${MY_PV}"
	KEYWORDS="-* ~amd64 ~arm64 ~x86"
fi

LICENSE="MIT"
RESTRICT="strip"

RDEPEND="app-arch/p7zip"

QA_PREBUILT="*"

src_unpack() {
	if [[ ${PV} == 9999 ]] ; then
		NIGHTLIES_S3="https://julialangnightlies-s3.julialang.org/bin"
		if use x86; then
			URI="${NIGHTLIES_S3}/linux/x86/${MY_P}-linux32.tar.gz"
		elif use amd64; then
			URI="${NIGHTLIES_S3}/linux/x64/${MY_P}-linux64.tar.gz"
		elif use arm64; then
			URI="${NIGHTLIES_S3}/linux/aarch64/${MY_P}-linuxaarch64.tar.gz"
		else
			die "arch not supported"
		fi

		edo wget -O "${T}/julia.tar.gz" "${URI}" || die
		unpack "${T}/julia.tar.gz"
	else
		default
	fi
}

src_test() {
	# Smoke test to catch issues like bug #956047
	if [[ ${PV} == 9999 ]] ; then
		edo ./julia-*/bin/julia --version
	else
		edo bin/julia --version
	fi
}

src_install() {
	insinto "/usr/$(get_libdir)/${MY_P}/"
	exeinto "/usr/$(get_libdir)/${MY_P}/bin"

	if [[ ${PV} == 9999 ]] ; then
		doins -r ./julia-*/etc
		doins -r ./julia-*/include
		doins -r ./julia-*/lib
		doins -r ./julia-*/share

		doexe ./julia-*/bin/julia
		dosym "../$(get_libdir)/${MY_P}/bin/julia" "/usr/bin/julia${PV}"
	else
		doins -r ./etc
		doins -r ./include
		doins -r ./lib
		doins -r ./share

		doexe bin/${MY_PN}
		dosym "../$(get_libdir)/${MY_P}/bin/${MY_PN}" "/usr/bin/${MY_PN}${SLOT}"

		local revord=$(( 9999 - $(ver_cut 1) * 100 - $(ver_cut 2) )) # 1.6 -> 106
		newenvd - 99${MY_PN}${revord} <<-EOF
		PATH="${EPREFIX}/usr/$(get_libdir)/${MY_P}/bin"
		EOF
	fi

	elog "QA warnings about unresolved SONAME dependencies can be safely ignored."
}
