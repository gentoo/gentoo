# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit multilib toolchain-funcs versionator

MY_P="${PN^^}${PV}"

DESCRIPTION="Software for interior-point for semidefinite programming"
HOMEPAGE="https://www.mcs.anl.gov/hs/software/DSDP/"
SRC_URI="https://www.mcs.anl.gov/hs/software/DSDP/${MY_P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos"
IUSE="doc examples"

RDEPEND="virtual/lapack"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

S="${WORKDIR}/${MY_P}"

PATCHES=(
	"${FILESDIR}"/${P}-readsdpa.patch
	"${FILESDIR}"/${P}-malloc.patch
	"${FILESDIR}"/${P}-gold.patch
)

make_shared_lib() {
	local soname=$(basename "${1%.a}")$(get_libname $(get_major_version))
	local cflags=()

	if [[ ${CHOST} == *-darwin* ]] ; then
		cflags+=(
			"-Wl,-install_name"
			"-Wl,${EPREFIX}/usr/$(get_libdir)/${soname}"
		)
	else
		cflags+=(
			"-shared" "-Wl,-soname=${soname}"
			"-Wl,--whole-archive" "${1}" "-Wl,--no-whole-archive"
		)
	fi
	einfo "Making ${soname}"
	${2:-$(tc-getCC)} ${LDFLAGS}  \
		"${cflags[@]}" \
		-o $(dirname "${1}")/"${soname}" \
		-lm $($(tc-getPKG_CONFIG) --libs blas lapack) || return 1
}

src_prepare() {
	default
	# to do proper parallel compilation
	while IFS="" read -d $'\0' -r file; do
		sed -i -e 's:make :$(MAKE) :g' "${file}" || die
	done < <(find . -name Makefile -print0)
	sed -i -e 's:make clean:$(MAKE) clean:g' make.include || die
	sed -i \
		-e "s|#\(DSDPROOT[[:space:]]*=\).*|\1${S}|" \
		-e "s|\(CC[[:space:]]*=\).*|\1$(tc-getCC)|" \
		-e "s|\(OPTFLAGS[[:space:]]*=\).*|\1${CFLAGS}|" \
		-e "s|\(CLINKER[[:space:]]*=\).*|\1 \${CC} ${LDFLAGS}|" \
		-e "s|\(LAPACKBLAS[[:space:]]*=\).*|\1 $($(tc-getPKG_CONFIG) --libs blas lapack)|" \
		-e "s|\(^ARCH[[:space:]]*=\).*|\1$(tc-getAR) cr|" \
		-e "s|\(^RANLIB[[:space:]]*=\).*|\1$(tc-getRANLIB)|" \
		make.include || die
}

src_compile() {
	emake OPTFLAGS="${CFLAGS} -fPIC" dsdplibrary
	make_shared_lib lib/lib${PN}.a || die "doing shared lib failed"
}

src_test() {
	emake -j1 example test
}

src_install() {
	dolib.so lib/lib${PN}$(get_libname $(get_major_version))
	dosym lib${PN}$(get_libname $(get_major_version)) \
		/usr/$(get_libdir)/lib${PN}$(get_libname)

	doheader include/*.h src/sdp/*.h

	use doc && DOCS+=( docs/*.pdf )
	use examples && DOCS+=( examples/. )
	einstalldocs
}
