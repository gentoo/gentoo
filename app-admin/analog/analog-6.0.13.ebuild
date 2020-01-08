# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

MY_P="${PN}-src-6013ce"

DESCRIPTION="A webserver log analyzer"
HOMEPAGE="https://www.c-amie.co.uk/software/analog/"
SRC_URI="http://www.c-amie.co.uk/static/analog/6013/${MY_P}.zip"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ppc ppc64 sparc x86"

DEPEND="
	app-arch/unzip
	>=dev-libs/libpcre-3.4
	>=media-libs/gd-1.8.4-r2[jpeg,png]
	sys-libs/zlib"

RDEPEND="
	${DEPEND}"

S="${WORKDIR}/${MY_P}"

PATCHES=(
	"${FILESDIR}"/${PN}-5.1-gentoo.diff
	"${FILESDIR}"/${PN}-6.0-bzip2.patch
	"${FILESDIR}"/${PN}-6.0-undefined-macro.patch
)

src_prepare() {
	default
	sed -i src/Makefile \
		-e 's| -o | $(LDFLAGS)&|g' \
		|| die "sed Makefile"
}

src_compile() {
	tc-export CC
	# emake in main dir just executes "cd src && make",
	# i.e. MAKEOPTS are ignored
	emake -C src
}

src_install() {
	newman analog.man analog.1

	dodoc README.txt Licence.txt analog.cfg
	dodoc -r examples
	docinto html
	dodoc docs/*.{html,gif,css,ico}
	dodoc -r how-to
	docinto cgi
	dodoc anlgform.pl

	insinto /usr/share/analog/images ; doins images/*
	insinto /usr/share/analog/lang ; doins lang/*
	dodir /var/log/analog
	dosym ../../../usr/share/analog/images /var/log/analog/images
	insinto /etc/analog ; doins "${FILESDIR}/analog.cfg"
	dobin analog
}
