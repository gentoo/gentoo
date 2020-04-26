# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools bash-completion-r1

DESCRIPTION="A HTTP regression testing and benchmarking utility"
HOMEPAGE="https://www.joedog.org/siege-home https://github.com/JoeDog/siege"
SRC_URI="http://download.joedog.org/${PN}/${P}.tar.gz"

LICENSE="GPL-3"
KEYWORDS="~amd64 ~arm ~hppa ~mips ~ppc ~x86 ~x64-macos"
SLOT="0"
IUSE="libressl ssl"

RDEPEND="ssl? (
		!libressl? ( dev-libs/openssl:0= )
		libressl? ( dev-libs/libressl:0= )
	)"
DEPEND="${RDEPEND}"

src_prepare() {
	default
	# bundled macros break recent libtool
	sed -i -e '/AC_PROG_SHELL/d' configure.ac || die
	rm *.m4 || die "failed to remove bundled macros"
	eautoreconf
}

src_configure() {
	local myconf=(
		$(use_with ssl ssl "${EPREFIX}/usr")
	)
	econf "${myconf[@]}"
}

src_install() {
	emake DESTDIR="${D}" install

	dodoc AUTHORS ChangeLog INSTALL README* doc/siegerc doc/urls.txt

	newbashcomp "${FILESDIR}"/${PN}.bash-completion ${PN}
}

pkg_postinst() {
	elog "An example ~/.siegerc file has been installed in"
	elog "${EPREFIX}/usr/share/doc/${PF}/"
}
