# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit fortran-2 toolchain-funcs

DESCRIPTION="C library of sparse linear solvers"
HOMEPAGE="https://github.com/sivantoledo/taucs/"
SRC_URI="https://github.com/sivantoledo/taucs/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc"
RESTRICT="test"

RDEPEND="
	sci-libs/metis
	virtual/blas
	virtual/lapack"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

PATCHES=(
	# bug 725588
	"${FILESDIR}"/${PN}-2.2-respect-ar.patch
	"${FILESDIR}"/${PN}-2.2-missing-include.patch
	"${FILESDIR}"/${P}-C23.patch
	"${FILESDIR}"/${P}-allocate-memory-in-test.patch
)

src_configure() {
	cat > config/linux_shared.mk <<-EOF || die
		AR=$(tc-getAR)
		FC=$(tc-getFC)
		CC=$(tc-getCC)
		LD=$(tc-getFC)
		RANLIB=$(tc-getRANLIB)
		CFLAGS=${CFLAGS} -fPIC
		FFLAGS=${FFLAGS} -fPIC
		LDFLAGS=${LDFLAGS} -fPIC
		LIBBLAS=$($(tc-getPKG_CONFIG) --libs blas)
		LIBLAPACK=$($(tc-getPKG_CONFIG) --libs lapack)
		LIBMETIS=$($(tc-getPKG_CONFIG) --libs metis)
		LIBF77=
	EOF
	# no cat <<EOF because -o has a trailing space
	cp config/linux.mk config/linux-musl.mk
	cp config/linux_shared.mk config/linux-musl_shared.mk
}

src_compile() {
	# not autotools configure. Uses difference in mkdir signature
	# between windows and linux to recognize system.
	CC="$(tc-getCC)" ./configure variant=_shared || die
	emake

	cd lib/linux$(usev elibc_musl -musl)_shared || die
	$(tc-getFC) ${LDFLAGS} -shared -Wl,-soname=libtaucs.so.1 \
		-Wl,--whole-archive libtaucs.a -Wl,--no-whole-archive \
		$($(tc-getPKG_CONFIG) --libs blas lapack metis) \
		-o libtaucs.so.1.0.0 \
		|| die "shared lib linking failed"
}

src_test() {
	LD_LIBRARY_PATH=lib/linux$(usev elibc_musl -musl)_shared \
		./testscript variant=_shared || die "compile test failed"
	if grep -q FAILED testscript.log; then
		eerror "Test failed. See ${S}/testscript.log"
		die "test failed"
	fi
}

src_install() {
	ln -s libtaucs.so.1.0.0 lib/linux$(usev elibc_musl -musl)_shared/libtaucs.so.1 || die
	ln -s libtaucs.so.1 lib/linux$(usev elibc_musl -musl)_shared/libtaucs.so || die
	dolib.so lib/linux$(usev elibc_musl -musl)_shared/libtaucs.so*

	doheader build/*/*.h src/*.h

	use doc && dodoc doc/*.pdf
}
