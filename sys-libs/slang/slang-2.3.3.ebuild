# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit multilib-minimal

DESCRIPTION="Multi-platform library designed to allow a developer to create robust software"
HOMEPAGE="https://www.jedsoft.org/slang/"

if [[ ${PV} == *_pre* ]] ; then
	MY_P="${PN}-pre${PV/_pre/-}"
	SRC_URI="https://www.jedsoft.org/snapshots/${MY_P}.tar.gz"
	S="${WORKDIR}/${MY_P}"
else
	SRC_URI="https://www.jedsoft.org/releases/${PN}/${P}.tar.bz2
		https://www.jedsoft.org/releases/${PN}/old/${P}.tar.bz2"
	KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~loong ~mips ppc ppc64 ~riscv ~s390 sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos"
fi

LICENSE="GPL-2"
SLOT="0"
IUSE="cjk pcre png readline static-libs zlib"

# ncurses for ncurses5-config to get terminfo directory
RDEPEND="
	sys-libs/ncurses:=
	cjk? ( >=dev-libs/oniguruma-5.9.5:=[${MULTILIB_USEDEP}] )
	pcre? ( >=dev-libs/libpcre-8.33-r1[${MULTILIB_USEDEP}] )
	png? ( >=media-libs/libpng-1.6.10:=[${MULTILIB_USEDEP}] )
	readline? ( >=sys-libs/readline-6.2_p5-r1:=[${MULTILIB_USEDEP}] )
	zlib? ( >=sys-libs/zlib-1.2.8-r1[${MULTILIB_USEDEP}] )
"
DEPEND="${RDEPEND}"

MAKEOPTS+=" -j1"

PATCHES=(
	"${FILESDIR}"/${PN}-2.3.3-slsh-libs.patch
	"${FILESDIR}"/${PN}-2.3.3-remove-undefined-symbol-from-version-script.patch
)

src_prepare() {
	default

	# Avoid linking to -ltermcap race with some systems
	sed -i -e '/^TERMCAP=/s:=.*:=:' configure || die
	# We use the GNU linker also on Solaris
	sed -i -e 's/-G -fPIC/-shared -fPIC/g' \
		-e 's/-Wl,-h,/-Wl,-soname,/g' configure || die

	# slang does not support configuration from another dir
	multilib_copy_sources
}

multilib_src_configure() {
	local myeconfargs=(
		--with-readline=$(usex readline gnu slang)
		$(use_with pcre)
		$(use_with cjk onig)
		$(use_with png)
		$(use_with zlib z)
	)

	econf "${myeconfargs[@]}"
}

multilib_src_compile() {
	emake elf $(usex static-libs static '')
	emake -C slsh slsh
}

multilib_src_install() {
	emake DESTDIR="${D}" install $(usex static-libs install-static '')
}

multilib_src_install_all() {
	rm -r "${ED}"/usr/share/doc/{slang,slsh} || die

	local -a DOCS=( NEWS README *.txt doc/{,internal,text}/*.txt )
	local -a HTML_DOCS=( doc/slangdoc.html slsh/doc/html/*.html )

	einstalldocs
}
