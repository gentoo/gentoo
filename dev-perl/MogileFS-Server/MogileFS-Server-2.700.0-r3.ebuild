# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

MODULE_AUTHOR=DORMANDO
MODULE_VERSION=${PV%0.0}
inherit user perl-module

DESCRIPTION="Server for the MogileFS distributed file system"
HOMEPAGE="http://www.danga.com/mogilefs/ ${HOMEPAGE}"

IUSE="mysql sqlite postgres"

SLOT="0"
LICENSE="|| ( Artistic GPL-2 )"
KEYWORDS="~amd64 ~ppc ~x86"

# Upstream site recommends this,
# but it breaks Perlbal
# dev-perl/Perlbal-XS-HTTPHeaders
RDEPEND="dev-perl/Net-Netmask
		>=dev-perl/Danga-Socket-1.610.0
		>=dev-perl/Sys-Syscall-0.220.0
		>=dev-perl/Perlbal-1.790
		>=dev-perl/IO-AIO-4
		dev-perl/libwww-perl
		>=dev-perl/MogileFS-Client-1.170.0
		>=dev-perl/MogileFS-Utils-2.280.0
		dev-perl/Cache-Memcached
		mysql? ( dev-perl/DBD-mysql )
		postgres? ( dev-perl/DBD-Pg )
		sqlite? ( dev-perl/DBD-SQLite )"
DEPEND="${RDEPEND}"

# You need a local MySQL or Postgresql server for this
#SRC_TEST="do"

#PATCHES=(  )

MOGILE_USER="mogile"

pkg_setup() {
	# Warning! It is important that the uid is constant over Gentoo machines
	# As mogilefs may be used with non-local block devices that move!
	enewuser ${MOGILE_USER} 460 -1 -1
}

src_prepare() {
	for f in Makefile.PL MANIFEST ; do
		if [ -f "${S}"/${f}.orig ]; then
			cp -f "${S}"/${f}{.orig,}
		else
			cp -f "${S}"/${f}{,.orig}
		fi
	done
	# If we are not in a cutting edge Git source, we would prefer to not install
	# duplicates of these.
	sed -i -e '/directory.*mogdeps/d' "${S}"/Makefile.PL
	sed -i -e '/^lib\/mogdeps/d' "${S}"/MANIFEST
	mv -f "${S}/lib/mogdeps" "${S}"
}

src_compile() {
	export MOGILE_NO_BUILTIN_DEPS=1
	perl-module_src_compile || die "perl-module_src_compile failed"
}

src_install() {
	export MOGILE_NO_BUILTIN_DEPS=1
	perl-module_src_install || die "perl-module_src_install failed"
	cd "${S}"

	newconfd "${FILESDIR}"/mogilefsd-conf.d-2.16 mogilefsd
	newinitd "${FILESDIR}"/mogilefsd-init.d-2.66 mogilefsd

	newconfd "${FILESDIR}"/mogstored-conf.d-2.30 mogstored
	newinitd "${FILESDIR}"/mogstored-init.d-2.70 mogstored

	newinitd "${FILESDIR}"/mogautomount-init.d-2.50 mogautomount

	diropts -m 700 -o ${MOGILE_USER}
	keepdir /var/run/mogile
	keepdir /var/mogdata
	diropts -m 755 -o root

	dodir /etc/mogilefs
	insinto /etc/mogilefs
	insopts -m 600 -o root -g ${MOGILE_USER}
	newins "${FILESDIR}"/mogilefsd.conf-2.30 mogilefsd.conf
	newins "${FILESDIR}"/mogstored.conf-2.16 mogstored.conf
}

pkg_postinst() {
	chmod 640 "${ROOT}"/etc/mogilefs/{mogilefsd,mogstored}.conf
	chown root:${MOGILE_USER} "${ROOT}"/etc/mogilefs/{mogilefsd,mogstored}.conf
}
