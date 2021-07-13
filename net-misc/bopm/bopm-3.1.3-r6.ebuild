# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools

DESCRIPTION="Blitzed Open Proxy Monitor"
HOMEPAGE="https://github.com/blitzed-org/bopm"
SRC_URI="http://static.blitzed.org/www.blitzed.org/${PN}/files/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~ppc ~x86"

RDEPEND="acct-user/opm"

PATCHES=(
	"${FILESDIR}"/${P}-remove-njabl.patch
	"${FILESDIR}"/${P}-autotools.patch
	"${FILESDIR}"/${P}-quarantine-bad-pid-file.patch
)

src_prepare() {
	sed -i \
		-e "s!/some/path/bopm.pid!/run/${PN}/${PN}.pid!" \
		-e "s!/some/path/scan.log!/var/log/${PN}/scan.log!" \
		bopm.conf.sample || die

	mv configure.{in,ac} || die
	mv src/libopm/configure.{in,ac} || die

	default
	cp bopm.conf{.sample,} || die

	eautoreconf
}

src_configure() {
	econf --localstatedir="${EPREFIX}"/var/log/${PN}
}

src_install() {
	default

	# Remove libopm related files, because bopm links statically to it
	# TODO: Do we really want libopm? It's gone now.
	# (was: "If anybody wants libopm, please install net-libs/libopm")
	rm -r "${ED}"/usr/$(get_libdir) "${ED}"/usr/include || die

	newinitd "${FILESDIR}"/bopm.init.d-r2 ${PN}
	newconfd "${FILESDIR}"/bopm.conf.d-r1 ${PN}

	dodir /var/log/bopm
	fperms 700 /var/log/bopm
	fowners opm:root /var/log/bopm

	fperms 600 /etc/bopm.conf
	fowners opm:root /etc/bopm.conf
}

pkg_postinst() {
	if [[ -n "${REPLACING_VERSIONS}" ]] ; then
		if has_version "<${CATEGORY}/${PN}-3.1.3-r6" ; then
			ewarn "You need to update permissions on:"
			ewarn "- /var/log/bopm"
			ewarn "- /etc/bopm.conf"
			ewarn "to be owned by opm:root"
		fi
	fi
}
