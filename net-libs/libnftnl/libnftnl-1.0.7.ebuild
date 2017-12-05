# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit autotools linux-info toolchain-funcs

DESCRIPTION="Netlink API to the in-kernel nf_tables subsystem"
HOMEPAGE="http://netfilter.org/projects/nftables/"
SRC_URI="http://netfilter.org/projects/${PN}/files/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0/4"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~ppc ~ppc64 ~x86"
IUSE="examples json static-libs test threads"

RDEPEND=">=net-libs/libmnl-1.0.0
	json? ( >=dev-libs/jansson-2.3 )"
DEPEND="virtual/pkgconfig
	${RDEPEND}"

REQUIRED_USE="test? ( json )"

pkg_setup() {
	if kernel_is ge 3 13; then
		CONFIG_CHECK="~NF_TABLES"
		linux-info_pkg_setup
	else
		eerror "This package requires kernel version 3.13 or newer to work properly."
	fi
}
src_prepare() {
	default
	eautoreconf
}

src_configure() {
	econf \
		$(use_enable static-libs static) \
		$(use_with json json-parsing)
}

src_test() {
	default
	cd tests || die
	./test-script.sh || die
}

src_install() {
	default
	gen_usr_ldscript -a nftnl
	find "${D}" -name '*.la' -delete || die "Could not rm libtool files"

	if use examples; then
		find examples/ -name 'Makefile*' -delete || die "Could not rm examples"
		dodoc -r examples
		docompress -x /usr/share/doc/${PF}/examples
	fi
}
