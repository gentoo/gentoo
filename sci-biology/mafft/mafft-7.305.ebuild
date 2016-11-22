# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit flag-o-matic toolchain-funcs

EXTENSIONS="-without-extensions"

DESCRIPTION="Multiple sequence alignments using a variety of algorithms"
HOMEPAGE="http://mafft.cbrc.jp/alignment/software/index.html"
SRC_URI="http://mafft.cbrc.jp/alignment/software/${P}${EXTENSIONS}-src.tgz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux ~x64-macos ~x86-macos"
IUSE="threads"

S="${WORKDIR}/${P}${EXTENSIONS}"

src_prepare() {
	default

	append-cflags -Wno-unused-result
	use threads && append-cppflags -Denablemultithread

	sed \
		-e 's/(PREFIX)\/man/(PREFIX)\/share\/man/' \
		-e 's:$(LDFLAGS)::g' \
		-e 's:$(CC) -o $@:$(CC) $(LDFLAGS) -o $@:g' \
		-e 's:$(CC) -shared -o $@:$(CC) $(LDFLAGS) -shared -o $@:g' \
		-e '/INSTALL/s: -s : :g' \
		-i core/Makefile || die
}

src_compile() {
	cd core || die
	emake \
		$(usex threads ENABLE_MULTITHREAD="-Denablemultithread" ENABLE_MULTITHREAD="") \
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
	DOCS=( readme )
	einstalldocs

	cd core || die
	emake PREFIX="${ED%/}/usr" install
}
