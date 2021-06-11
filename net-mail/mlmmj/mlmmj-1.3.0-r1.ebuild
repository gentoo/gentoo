# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MY_PV="${PV/_rc/-RC}"
MY_P="${PN}-${MY_PV}"
DESCRIPTION="Mailing list managing made joyful"
HOMEPAGE="http://mlmmj.org/"
SRC_URI="http://mlmmj.org/releases/${MY_P}.tar.bz2"
S="${WORKDIR}/${MY_P}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ppc x86 ~amd64-linux ~x86-linux ~ppc-macos"

DEPEND="virtual/mta"

DOCS=( AUTHORS ChangeLog FAQ TODO TUNABLES UPGRADE )

PATCHES=(
	"${FILESDIR}"/mlmmj-1.2.19.0-listcontrol-customheaders.patch
	"${FILESDIR}"/mlmmj-1.3.0-gcc-10.patch
)

src_prepare() {
	default

	# bug #259962
	for file in $(find . -iname "*.cgi") ; do
		sed -i -e "s:/usr/local/bin/:${EPREFIX}/usr/bin/:" "${file}" || die
	done
}

src_configure() {
	econf --enable-receive-strip
}

src_install() {
	default

	insinto /usr/share/mlmmj/texts
	doins listtexts/*

	insinto /usr/share/mlmmj
	doins -r contrib/web/*

	dodoc README.*
}

pkg_postinst() {
	elog "mlmmj comes with serveral webinterfaces:"
	elog "- One for user subscribing/unsubscribing"
	elog "- One for admin tasks"
	elog "both available in a php and perl module."
	elog "For more info have a look in ${EROOT}/usr/share/mlmmj"
}
