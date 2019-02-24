# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
MY_PN=${PN/-bin/}
MY_P=${MY_PN}-${PV}

DESCRIPTION="High-performance programming language for technical computing"
HOMEPAGE="https://julialang.org/"
SRC_URI="
	x86? ( https://julialang-s3.julialang.org/bin/linux/x86/1.1/${MY_P}-linux-i686.tar.gz )
	amd64? ( https://julialang-s3.julialang.org/bin/linux/x64/1.1/${MY_P}-linux-x86_64.tar.gz )
	amd64-fbsd? ( https://julialang-s3.julialang.org/bin/freebsd/x64/1.1/${MY_P}-freebsd-x86_64.tar.gz )
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="-* ~amd64 ~x86 ~amd64-fbsd"
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

	exeinto "/usr/$(get_libdir)/${MY_P}/bin"
	doexe bin/julia

	cat > 99julia-bin <<-EOF
		PATH="${EROOT%/}/usr/$(get_libdir)/${MY_P}/bin"
	EOF
	doenvd 99julia-bin
}
