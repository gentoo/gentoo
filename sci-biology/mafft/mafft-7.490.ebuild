# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit flag-o-matic toolchain-funcs

EXTENSIONS="-without-extensions"

DESCRIPTION="Multiple sequence alignments using a variety of algorithms"
HOMEPAGE="https://mafft.cbrc.jp/alignment/software/index.html"
SRC_URI="https://mafft.cbrc.jp/alignment/software/${P}${EXTENSIONS}-src.tgz"
S="${WORKDIR}/${P}${EXTENSIONS}"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~x64-macos"

src_prepare() {
	default

	sed \
		-e 's/(PREFIX)\/man/(PREFIX)\/share\/man/' \
		-e 's:$(LDFLAGS)::g' \
		-e 's:$(CC) -o $@:$(CC) $(LDFLAGS) -o $@:g' \
		-e 's:$(CC) -shared -o $@:$(CC) $(LDFLAGS) -shared -o $@:g' \
		-e '/INSTALL/s: -s : :g' \
		-i core/Makefile || die
}

src_configure() {
	append-cflags -Wno-unused-result
}

src_compile() {
	emake -C core \
		PREFIX="${EPREFIX}"/usr \
		CC="$(tc-getCC)" \
		CFLAGS="${CFLAGS}"
}

src_test() {
	export MAFFT_BINARIES="${S}"/core
	cd test || die
	bash ../core/mafft sample > test.fftns2 || die "Tests failed"
	bash ../core/mafft --maxiterate 100  sample > test.fftnsi || die "Tests failed"
	bash ../core/mafft --globalpair sample > test.gins1 || die "Tests failed"
	bash ../core/mafft --globalpair --maxiterate 100  sample > test.ginsi || die "Tests failed"
	bash ../core/mafft --localpair sample > test.lins1 || die "Tests failed"
	bash ../core/mafft --localpair --maxiterate 100  sample > test.linsi || die "Tests failed"

	diff test.fftns2 sample.fftns2 || die "Tests failed"
	diff test.fftnsi sample.fftnsi || die "Tests failed"
	diff test.gins1 sample.gins1 || die "Tests failed"
	diff test.ginsi sample.ginsi || die "Tests failed"
	diff test.lins1 sample.lins1 || die "Tests failed"
}

src_install() {
	emake -C core DESTDIR="${D}" STRIP=":" PREFIX="${EPREFIX}"/usr install
	dodoc readme
}
