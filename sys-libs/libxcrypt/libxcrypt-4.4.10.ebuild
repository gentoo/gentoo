# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python3_{6,7} )
inherit python-any-r1 autotools

DESCRIPTION="Extended crypt library for descrypt, md5crypt, bcrypt, and others "
SRC_URI="https://github.com/besser82/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
HOMEPAGE="https://github.com/besser82/libxcrypt"

LICENSE="LGPL-2.1+ public-domain BSD BSD-2"
SLOT="0/2"
KEYWORDS="~amd64 ~x86"
IUSE="split-usr test"

BDEPEND="sys-apps/findutils
	test? ( ${PYTHON_DEPS} )"

# Gentoo CI complained about not having this
RESTRICT="!test? ( test )"

PATCHES=(
	"${FILESDIR}/libxcrypt-4.4.10-pythonver.patch"
)

pkg_setup() {
	use test && python-any-r1_pkg_setup
}

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	econf \
		--disable-static \
		--enable-obsolete-api=no \
		--libdir=$(usex split-usr '/usr' '')/$(get_libdir)/xcrypt \
		--with-pkgconfigdir=/usr/$(get_libdir)/pkgconfig \
		--includedir="${EPREFIX}/usr/include/xcrypt"
}

src_test() {
	emake check
}

src_install() {
	default

	# make sure out man pages don't collide with glibc or man-pages
	(
		shopt -s failglob || die "failglob failed"
		for manpage in "${ED}"/usr/share/man/man*/*.?*; do
			mv -n "${manpage}" "$(dirname "${manpage}")/xcrypt_$(basename "${manpage}")" \
				|| die "mv failed"
		done
	) || die "no man pages to rename"
}
