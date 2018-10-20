# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

inherit autotools

DESCRIPTION="A small XML parsing library that you can use to read XML data files or strings"
HOMEPAGE="https://github.com/michaelrsweet/mxml
	https://www.msweet.org/mxml/"
SRC_URI="https://github.com/michaelrsweet/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86"
LICENSE="Mini-XML"
SLOT="0"
IUSE="static-libs threads"

BDEPEND="virtual/pkgconfig"

src_prepare() {
	default

	# Respect users CFLAGS
	sed -e 's/-Os -g//' -i configure.ac || die

	# Don't run always tests
	# Enable verbose compiling
	sed -e '/ALLTARGETS/s/testmxml//g' -e '/.SILENT:/d' -i Makefile.in || die

	# Build only static-libs, when requested by user, also build docs without static-libs in that case
	if ! use static-libs; then
		local mysedopts=(
			-e '/^install:/s/install-libmxml.a//g'
			-e '/^mxml.xml:/s/-static//g'
			-e '/^mxml.epub:/s/-static//g'
			-e '/^valgrind/s/-static//g'
			-e 's/.\/mxmldoc-static/LD_LIBRARY_PATH="." .\/mxmldoc/g'
		)
		sed "${mysedopts[@]}" -i Makefile.in || die
	fi

	eautoconf
}

src_configure() {
	local myeconfopts=(
		$(use_enable threads)
		--with-docdir=/usr/share/doc/${PF}
	)

	econf "${myeconfopts[@]}"
}

src_test() {
	emake testmxml
}

src_install() {
	emake DSTROOT="${ED}" install
}
