# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit autotools

DESCRIPTION="NFSv4 ID <-> name mapping library"
HOMEPAGE="http://www.citi.umich.edu/projects/nfsv4/linux/"
#SRC_URI="http://www.citi.umich.edu/projects/nfsv4/linux/libnfsidmap/${P}.tar.gz"
SRC_URI="https://fedorapeople.org/~steved/${PN}/${PV}/${P}.tar.bz2"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~ia64 ~m68k ~mips ppc ppc64 ~s390 sparc x86"
IUSE="ldap static-libs"

DEPEND="ldap? ( net-nds/openldap:= )"
RDEPEND="
	${DEPEND}
	!<net-fs/nfs-utils-1.2.2
	!net-fs/idmapd
"

PATCHES=(
	"${FILESDIR}"/${PN}-0.27-getgrouplist.patch #169909
	"${FILESDIR}"/${PN}-0.21-headers.patch
)

src_prepare() {
	default
	# Ideally the build would use -DLIBDIR=$(libdir) at build time.
	sed -i \
		-e "/PATH_PLUGINS/s:/usr/lib/libnfsidmap:${EPREFIX}/usr/$(get_libdir)/libnfsidmap:" \
		libnfsidmap.c || die #504666
	eautoreconf
}

src_configure() {
	local myeconfargs=(
		$(use_enable static-libs static)
		$(use_enable ldap)
	)
	econf "${myeconfargs[@]}"
}

src_install() {
	default

	insinto /etc
	doins idmapd.conf

	# remove useless files
	rm -f "${ED%/}"/usr/$(get_libdir)/libnfsidmap/*.{a,la}
	use static-libs || find "${ED%/}"/usr -name '*.la' -delete || die
}
