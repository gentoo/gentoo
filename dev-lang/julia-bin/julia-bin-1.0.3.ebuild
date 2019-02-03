# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
MY_PN=${PN/-bin/}
MY_P=${MY_PN}-${PV}

DESCRIPTION="High-performance programming language for technical computing"
HOMEPAGE="https://julialang.org/"
SRC_URI="
	x86? ( https://julialang-s3.julialang.org/bin/linux/x86/1.0/${MY_P}-linux-i686.tar.gz )
	amd64? ( https://julialang-s3.julialang.org/bin/linux/x64/1.0/${MY_P}-linux-x86_64.tar.gz )
	arm? ( https://julialang-s3.julialang.org/bin/linux/armv7l/1.0/${MY_P}-linux-armv7l.tar.gz )
	arm64? ( https://julialang-s3.julialang.org/bin/linux/aarch64/1.0/${MY_P}-linux-aarch64.tar.gz )
	amd64-fbsd? ( https://julialang-s3.julialang.org/bin/freebsd/x64/1.0/${MY_P}-freebsd-x86_64.tar.gz )
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="-* ~amd64 ~arm ~arm64 ~x86 ~amd64-fbsd"
IUSE="elibc_glibc elibc_FreeBSD"

RDEPEND="!dev-lang/julia"
DEPEND="${RDEPEND}"

S="${WORKDIR}/${MY_P}"

src_install() {
	insinto "/usr/$(get_libdir)/${MY_P}/"
	doins -r ./etc
	doins -r ./include
	doins -r ./lib
	doins -r ./share
	dosym "../$(get_libdir)/${MY_P}/bin/julia" "${EPREFIX}/usr/bin/julia"

	exeinto "/usr/$(get_libdir)/${MY_P}/bin"
	doexe bin/julia

	cat > 99julia-bin <<-EOF
		LDPATH=${EROOT%/}/opt/${MY_P}
	EOF
	doenvd 99julia-bin
}
