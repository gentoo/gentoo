# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit eutils flag-o-matic multilib toolchain-funcs

EXTENSIONS="-without-extensions"

DESCRIPTION="Multiple sequence alignments using a variety of algorithms"
HOMEPAGE="https://mafft.cbrc.jp/alignment/software/index.html"
SRC_URI="https://mafft.cbrc.jp/alignment/software/${P}${EXTENSIONS}-src.tgz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux ~x64-macos ~x86-macos"
IUSE="threads"

S="${WORKDIR}"/${P}${EXTENSIONS}

src_prepare() {
#	epatch "${FILESDIR}"/${PN}-7.037-respect.patch
	use threads && append-cppflags -Denablemultithread
#	sed "s:GENTOOLIBDIR:$(get_libdir):g" -i core/Makefile || die
	sed -i -e "s/(PREFIX)\/man/(PREFIX)\/share\/man/" "${S}"/core/Makefile || die "sed failed"
	sed \
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
		CFLAGS="${CFLAGS} -Wno-unused-result"
}

src_test() {
	export MAFFT_BINARIES="${S}"/core
	cd test || die
	bash ../core/mafft sample > test.fftns2 || die
	bash ../core/mafft --maxiterate 100  sample > test.fftnsi || die
	bash ../core/mafft --globalpair sample > test.gins1 || die
	bash ../core/mafft --globalpair --maxiterate 100  sample > test.ginsi || die
	bash ../core/mafft --localpair sample > test.lins1 || die
	bash ../core/mafft --localpair --maxiterate 100  sample > test.linsi || die

	diff test.fftns2 sample.fftns2 || die
	diff test.fftnsi sample.fftnsi || die
	diff test.gins1 sample.gins1 || die
	diff test.ginsi sample.ginsi || die
	diff test.lins1 sample.lins1 || die
}

src_install() {
	dodoc readme
	cd core || die
	emake PREFIX="${ED}usr" install
}
