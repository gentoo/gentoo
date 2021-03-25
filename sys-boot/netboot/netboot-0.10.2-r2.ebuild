# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

DESCRIPTION="Allows to remote boot a computer over an IP network"
HOMEPAGE="http://netboot.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="berkdb +bootrom +lzo odbc static-libs"

DEPEND="
	berkdb? ( sys-libs/db:= )
	lzo? ( dev-libs/lzo:2= )
	odbc? ( dev-db/unixODBC:= )
"

RDEPEND="${DEPEND}"

PATCHES=(
	"${FILESDIR}/${P}-ldflags.patch"
	"${FILESDIR}/${P}-slibtool.patch"
)

src_prepare() {
	default

	# Don't	install	support	binaries into libdir
	sed -e "152s:nblibdir:bindir:" -e "153s:nblibdir:bindir:" -i misc/Makefile || die

	# Don't install perl script into libdir
	sed -e 's/nblibdir/nbmiscdir/g' -i mknbi-dos/utils/Makefile || die

	# Don't install vim syntax file, as it will be installed manually
	sed -e '/mgl.vim/d' -i mknbi-mgl/Makefile || die
}

src_configure() {
	local myeconfargs=(
		--datadir="/usr/share/netboot"
		$(use_with berkdb berkeley-db)
		$(use_enable bootrom)
		$(use_with lzo)
		$(use_with odbc)
		$(use_enable static-libs static)
		# Disable compilation of 16-bit assembler files,
		# since it's broken on x86 and not supported on x86_64.
		--with-gnu-as86="no"
		--with-gnu-cc86="no"
		--with-gnu-ld86="no"
	)

	econf "${myeconfargs[@]}"
}

src_compile() {
	# mknbi fails with parallel build
	emake -j1
}

src_install() {
	emake DESTDIR="${ED}" install

	insinto /usr/share/vim/vimfiles/syntax
	doins "${S}"/mknbi-mgl/misc/mgl.vim

	dodoc README doc/{HISTORY,PROBLEMS,README.*,Spec.doc}

	docinto flashcard
	dodoc FlashCard/README FlashCard/*.ps

	find "${D}" -name '*.la' -type f -delete || die
}
