# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools edos2unix

DESCRIPTION="Library to load, handle and manipulate images in the PGF format"
HOMEPAGE="https://libpgf.org/"
SRC_URI="https://downloads.sourceforge.net/project/libpgf/libpgf/${PV}/libpgf.zip -> ${P}.zip"
S="${WORKDIR}/libpgf"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="doc"

BDEPEND="
	app-arch/unzip
	doc? (
		app-text/doxygen
		dev-texlive/texlive-fontutils
	)
"

PATCHES=(
	"${FILESDIR}"/${P}-remove-off64_t.patch
)

src_prepare() {
	default

	# configure.ac has wrong version number
	sed -i "s/7.15.32/${PV}/g" configure.ac || die

	# many files, including configure.ac and Makefile.am, are saved in dos format, causing errors in autotools
	edos2unix *.{am,ac,in,sh} */*.{am,in}

	# the package does not respect --docdir and installs docs in /usr/share/doc/${PN}
	sed -i -e 's/\$(DOC_DIR)/$(DESTDIR)@docdir@/' doc/Makefile.am || die

	if ! use doc; then
		sed -i -e "/HAS_DOXYGEN/{N;N;d}" Makefile.am || die
	fi

	eautoreconf
}

src_install() {
	default

	if use doc; then
		docinto pdf
		dodoc doc/*.pdf doc/latex/*.pdf
	fi

	find "${ED}" -name '*.la' -delete || die
}
