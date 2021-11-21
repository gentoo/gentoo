# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
MY_PN=${PN/-bin/}
MY_P=${MY_PN}-${PV/_/-}
MY_PV=$(ver_cut 1-2)
BASE_SRC_URI="https://julialang-s3.julialang.org/bin"

DESCRIPTION="High-performance programming language for technical computing"
HOMEPAGE="https://julialang.org/"
SRC_URI="
	x86? ( ${BASE_SRC_URI}/linux/x86/${MY_PV}/${MY_P}-linux-i686.tar.gz )
	amd64? (
		elibc_glibc? ( ${BASE_SRC_URI}/linux/x64/${MY_PV}/${MY_P}-linux-x86_64.tar.gz )
		elibc_musl? ( ${BASE_SRC_URI}/musl/x64/${MY_PV}/${MY_P}-musl-x86_64.tar.gz )
	)
	amd64-fbsd? ( ${BASE_SRC_URI}/freebsd/x64/${MY_PV}/${MY_P}-freebsd-x86_64.tar.gz )
	arm64? ( ${BASE_SRC_URI}/linux/aarch64/${MY_PV}/${MY_P}-linux-aarch64.tar.gz )
	ppc64? ( ${BASE_SRC_URI}/linux/ppc64le/${MY_PV}/${MY_P}-linux-ppc64le.tar.gz )
"

LICENSE="MIT"
SLOT="${MY_PV}"
KEYWORDS="-* ~amd64 ~x86"
IUSE="elibc_glibc"

RDEPEND="
	!dev-lang/julia
	app-arch/p7zip
"
DEPEND="${RDEPEND}"

RESTRICT="strip"

QA_PREBUILT="*"
QA_SONAME="*"

S="${WORKDIR}/${MY_P}"

src_install() {
	insinto "/usr/$(get_libdir)/${MY_P}/"
	doins -r ./etc
	doins -r ./include
	doins -r ./lib
	doins -r ./share

	exeinto "/usr/$(get_libdir)/${MY_P}/bin"
	doexe "bin/${MY_PN}"
	dosym "../$(get_libdir)/${MY_P}/bin/${MY_PN}" "/usr/bin/${MY_PN}${SLOT}"

	local revord=$(( 9999 - $(ver_cut 1) * 100 - $(ver_cut 2) )) # 1.6 -> 106
	newenvd - 99${MY_PN}${revord} <<-EOF
		PATH="${EROOT}/usr/$(get_libdir)/${MY_P}/bin"
	EOF
}
