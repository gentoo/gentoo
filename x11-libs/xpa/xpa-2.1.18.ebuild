# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools toolchain-funcs

DESCRIPTION="Messaging system providing communication between programs"
HOMEPAGE="https://github.com/ericmandel/xpa"
SRC_URI="https://github.com/ericmandel/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0/1"
KEYWORDS="~amd64 ~ppc ~x86 ~amd64-linux ~x86-linux"
IUSE="doc"

RDEPEND="
	dev-lang/tcl:0=
	x11-libs/libXt:0"
DEPEND="${RDEPEND}"

PATCHES=(
	"${FILESDIR}"/${PN}-2.1.18-makefile.patch
	"${FILESDIR}"/${PN}-2.1.18-include.patch #637346
)

src_prepare() {
	default
	sed -e "s:\${LINK}:\${LINK} ${LDFLAGS}:" -i mklib || die
	eautoconf
}

src_configure() {
	tc-export AR CC

	econf \
		--enable-shared \
		--enable-threaded-xpans \
		--with-x \
		--with-tcl \
		--with-threads
}

src_compile() {
	emake shlib tclxpa
}

src_install() {
	dodir /usr/$(get_libdir)
	emake INSTALL_ROOT="${D}" install

	insinto /usr/$(get_libdir)/tclxpa
	doins pkgIndex.tcl

	mv "${ED}"/usr/$(get_libdir)/libtclxpa* \
		"${ED}"/usr/$(get_libdir)/tclxpa/ || die

	dodoc README
	use doc && dodoc doc/*.pdf && dodoc doc/*.html

	# no static archives
	rm "${ED}"/usr/$(get_libdir)/libxpa.a || die
}
