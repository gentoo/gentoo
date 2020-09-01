# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

PYTHON_COMPAT=( python2_7 )

inherit python-single-r1 multilib-minimal

DESCRIPTION="Library to query devices using IEEE1284"
HOMEPAGE="http://cyberelk.net/tim/software/libieee1284/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc x86"
IUSE="doc python static-libs"
REQUIRED_USE="python? ( ${PYTHON_REQUIRED_USE} )"

BDEPEND="doc? (
		app-text/docbook-sgml-utils
		>=app-text/docbook-sgml-dtd-4.1
		app-text/docbook-dsssl-stylesheets
		dev-perl/XML-RegExp
	)"

DEPEND="python? ( ${PYTHON_DEPS} )"

RDEPEND="${DEPEND}"

pkg_setup() {
	use python && python-single-r1_pkg_setup
}

multilib_src_configure() {
	local myeconfargs=(
		--enable-shared
		$(use_enable static-libs static)
		$(multilib_native_use_with python)
	)

	ECONF_SOURCE="${S}" econf "${myeconfargs[@]}"
}

multilib_src_install_all() {
	einstalldocs
	dodoc doc/interface*

	if ! use static-libs; then
		find "${ED}" -name '*.la' -delete || die
	fi
}
