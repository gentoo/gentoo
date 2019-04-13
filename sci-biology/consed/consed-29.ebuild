# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit flag-o-matic toolchain-funcs

DESCRIPTION="A genome sequence finishing program"
HOMEPAGE="http://bozeman.mbt.washington.edu/consed/consed.html"
SRC_URI="
	${P}-sources.tar.gz
	${P}-linux.tar.gz"

LICENSE="phrap"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="examples"

COMMON_DEPEND="
	x11-libs/libX11
	x11-libs/motif:0
	sci-biology/samtools:0.1-legacy
"
DEPEND="
	${COMMON_DEPEND}
	virtual/pkgconfig
"
RDEPEND="
	${COMMON_DEPEND}
	dev-lang/perl
	>=sci-biology/phred-071220-r1
	>=sci-biology/phrap-1.080812-r2
"

S="${WORKDIR}"

RESTRICT="fetch"
PATCHES=(
	"${FILESDIR}/${PN}-29-fix-build-system.patch"
	"${FILESDIR}/${PN}-29-fix-c++14.patch"
	"${FILESDIR}/${PN}-29-fix-qa.patch"
	"${FILESDIR}/${PN}-29-fix-perl-shebang.patch"
)

pkg_nofetch() {
	einfo "Please visit ${HOMEPAGE} and obtain the file"
	einfo "\"sources.tar.gz\", then rename it to \"${P}-sources.tar.gz\""
	einfo "and place it into your DISTDIR directory,"
	einfo "obtain the file"
	einfo "\"consed_linux.tar.gz\", then rename it to \"${P}-linux.tar.gz\""
	einfo "and place it into your DISTDIR directory."
}

src_prepare() {
	default

	sed \
		-e "s!\$szPhredParameterFile = .*!\$szPhredParameterFile = \$ENV{'PHRED_PARAMETER_FILE'} || \'"${EPREFIX}"/usr/share/phred/phredpar.dat\';!" \
		-e "s:/usr/local/genome:${EPREFIX}/usr:" \
		-e "s:niceExe = \"/bin/nice\":niceExe = \"${EPREFIX}/usr/bin/nice\":" \
		-e "s:/wt1/gordon/genome:${EPREFIX}/usr/bin:" \
		-i scripts/* contributions/* || die
}

src_configure() {
	append-cflags -std=gnu99
	append-lfs-flags
}

src_compile() {
	emake \
		CC="$(tc-getCC)" \
		CXX="$(tc-getCXX)" \
		CFLAGS="${CFLAGS}" \
		CXXFLAGS="${CXXFLAGS}" \
		CPPFLAGS="${CPPFLAGS}" \
		LDFLAGS="${LDFLAGS}" \
		SAMTOOLS_CPPFLAGS="-I${EPREFIX}/usr/include/bam-0.1-legacy" \
		LIBS="-L${EPREFIX}/usr/$(get_libdir)" \
		X11_LIBS="$($(tc-getPKG_CONFIG) --libs x11)" \
		SAMTOOLS_LIBS="-lbam-0.1-legacy"
}

src_install() {
	dobin consed misc/{mktrace/mktrace,phd2fasta/phd2fasta,454/sff2scf} scripts/* contributions/*

	insinto /usr/lib/screenLibs
	doins misc/*.{fa*,seq}

	if use examples; then
		insinto /usr/share/${PN}/examples
		doins -r \
			standard polyphred autofinish assembly_view 454_newbler \
			align454reads align454reads_answer solexa_example \
			solexa_example_answer selectRegions selectRegionsAnswer
	fi

	cat > 99consed <<-_EOF_ || die
	CONSED_HOME=${EPREFIX}/usr
	CONSED_PARAMETERS=${EPREFIX}/etc/consedrc
	_EOF_
	doenvd 99consed

	dodoc README.txt *_announcement.txt
}

pkg_postinst() {
	einfo "Package documentation is available at"
	einfo "http://www.phrap.org/consed/distributions/README.${PV}.0.txt"
}
